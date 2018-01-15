module Stations
  DATA = [
    { name: "holborn", zones: [1]},
    { name: "earls_court", zones: [1, 2]},
    { name: "wimbledon", zones: [3]},
    { name: "hammersmith", zones: [2]},
  ]

  NAMES = DATA.map { |e| e[:name] }
end
