require_relative "lib/custom_exceptions/custom_exceptions"
require_relative "lib/stations/stations"
require_relative "lib/fare/fare"
require_relative "lib/fare/calculator"

class User
  attr_reader :balance, :current_station, :fare_calculator

  def initialize
    @balance = 0.0
    @fare_calculator = Fare::Calculator.new
  end

  def bus_travel_to(from:, to:)
    puts "Travelling in bus..."
    subtract_from_balance(amount: Fare::BUS)
    puts "Bus travel from #{from} to #{to}."
  end

  def check_in(station:)
    puts "Checking in..."
    raise_invalid_station_error unless Stations::NAMES.include?(station)
    minimum_required_fare = fare_calculator.minimum_required_fare_from_a(station: station)
    raise StandardError, "You don't have the minimum fare required to check in" if balance < minimum_required_fare
    # charge_max_fare
    @current_station = station
    puts "Checked in to #{@current_station} station."
  end

  def travel_to(station:)
    raise_invalid_station_error unless Stations::NAMES.include?(station)
    "Travelling from #{@current_station} station to #{station} station."
    actual_fare = fare_calculator.fare_amount_between_destinations(from: current_station, to: station)
    # return_max_fare if checked_in?
    @current_station = nil
    subtract_from_balance(amount: actual_fare)
  end

  def checked_in?
    current_station
  end

  def top_up(amount:)
    raise CustomExceptions::InvalidTransaction, "Invalid Top Up amount: #{amount}" if amount.negative? || amount.zero?
    add_to_balance(amount: amount)
    puts "Congratulations! #{amount.to_f} is added to your account."
  end

  private

  def add_to_balance(amount:)
    raise_invalid_amount_error if amount.negative?
    @balance += amount
  end

  def subtract_from_balance(amount:)
    raise_invalid_amount_error if amount.negative?
    raise_insufficient_funds_error if (@balance - amount).negative?
    @balance -= amount
    puts "Charged #{amount}."
  end

  def return_max_fare
    add_to_balance(amount: Fare::MAX)
    puts "Returned max fare: #{Fare::MAX}."
  end

  def charge_max_fare; subtract_from_balance(amount: Fare::MAX); end
  def fare_calculator; @fare_calculator; end
  def raise_insufficient_funds_error; raise CustomExceptions::InvalidTransaction, "Insufficient funds"; end
  def raise_invalid_amount_error; raise CustomExceptions::InvalidTransaction, "Invalid amount"; end
  def raise_invalid_station_error; raise CustomExceptions::SystemError, "Invalid station"; end
end
