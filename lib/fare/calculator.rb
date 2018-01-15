module Fare
  class Calculator
    def fare_amount_between_destinations(from:, to:)
      @from_object = Stations::DATA.select { |station| station[:name] == from }.first
      @to_object = Stations::DATA.select { |station| station[:name] == to }.first

      return MAX unless @from_object

      from_object_station_index = Stations::DATA.index(@from_object)
      to_object_station_index = Stations::DATA.index(@to_object)

      same_zone = @from_object[:zones] & @to_object[:zones]
      # zones = @from_object[:zones] + @to_object[:zones]
      # zones_occurences = zones.each_with_object(Hash.new(0)) { |zone, zones_occurences| zones_occurences[zone] += 1 }
      # puts "#{zones_occurences}"
      #
      # same_zone = zones_occurences.values.include?(1)

      # if same_zone.count > 0 # same zone
      #   fare = same_zone_fare(to_object: @to_object)
      # else
        fare = non_same_zone_fare(from_object: @from_object, to_object: @to_object)
      # end

      puts "======fare: #{fare}"
      fare
    end

    def minimum_required_fare_from_a(station:)
      all_possible_destinations = Stations::DATA.map { |station| station[:name] }
      all_possible_destinations.reject! { |station_name| station_name == station }
      fares = []
      all_possible_destinations.each do |destination|
        fares << fare_amount_between_destinations(from: station, to: destination)
      end
      fares.min
    end

    def same_zone_fare(to_object:)
      all_fares = []
      applicable_fare_rules = RULES.select { |fare_rule| fare_rule[:no_of_zones] == 1 }
      applicable_fare_rules.each do |fare_rule|
        if fare_rule[:same_zone]
          common_zone = fare_rule[:only_zones] & to_object[:zones]
          all_fares << fare_rule[:fare] if common_zone.count > 0
        elsif fare_rule[:outside]
          excluding_zones = fare_rule[:excluding_zones] & to_object[:zones]
          all_fares << fare_rule[:fare] unless excluding_zones.count > 0
        else
          raise CustomExceptions::StandardError, "Invalid Scenario"
        end
      end
      all_fares.max
    end

    def non_same_zone_fare(from_object:, to_object:)
      all_fares = []
      applicable_fare_rules = RULES.select { |fare_rule| fare_rule[:no_of_zones] == 2 }
      applicable_fare_rules.each do |fare_rule|
        if fare_rule[:including]
          all_fares << fare_rule[:fare] if ((from_object[:zones] & fare_rule[:including_zones]).count > 0) || ((to_object[:zones] & fare_rule[:including_zones]).count > 0)
        elsif fare_rule[:excluding]
          all_fares << fare_rule[:fare] unless ((from_object[:zones] & fare_rule[:excluding_zones]).count > 0) || ((to_object[:zones] & fare_rule[:excluding_zones]).count > 0)
        else
          raise CustomExceptions::StandardError, "Invalid Scenario"
        end
      end
      puts "========debugge========== from_object: #{from_object}, to_object: #{to_object}"
      puts "======all_fares: #{all_fares}"
      all_fares.max
    end
  end
end
