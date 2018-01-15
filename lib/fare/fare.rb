module Fare
  RULES = [
    { no_of_zones: 1, only_zones: [1], same_zone: true, fare: 2.50 },
    { no_of_zones: 1, excluding_zones: [1], outside: true, fare: 2.0 },
    { no_of_zones: 2, including_zones: [1], including: true, fare: 3.0 },
    { no_of_zones: 2, excluding_zones: [1], excluding: true, fare: 2.25 },
    { no_of_zones: 3, fare: 3.20 },
  ]

  ALL = RULES.map { |rule| rule[:fare] }
  MAX = ALL.max
  BUS = 1.80
end
