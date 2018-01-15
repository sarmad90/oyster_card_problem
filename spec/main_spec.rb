require_relative "../user"
require_relative "../lib/fare/fare"
require_relative "../lib/fare/calculator"
require_relative "../lib/stations/stations"

RSpec.describe User do
  let(:user) { User.new }
  it "completes the described Scenario" do
    expect(user.balance).to eq(0.0)
    user.top_up(amount: 30.0)
    expect(user.balance).to eq(30.0)

    station = "holborn"
    user.check_in(station: station)
    expect(user.current_station).to eq(station)

    user.travel_to(station: "earls_court")
    expect(user.balance).to eq(27.0)

    user.bus_travel_to(from: "earls_court", to: "Chelsea")
    expect(user.balance).to eq(25.2)

    station = "earls_court"
    user.check_in(station: station)
    expect(user.current_station).to eq(station)

    user.travel_to(station: "hammersmith")
    expect(user.balance).to eq(22.2)
  end

  it "charges the max fare if a user swipes out without swiping in" do
    topup_amount = 30.0
    user.top_up(amount: topup_amount)

    expect(user.current_station).to be_nil
    user.travel_to(station: "earls_court")
    expect(user.balance).to eq(topup_amount - Fare::MAX)
  end

  it "fare calculator should return the max fare if the from location is nil" do
    calculator = Fare::Calculator.new
    fare = calculator.fare_amount_between_destinations(from: nil, to: "earls_court")
    expect(fare).to eq(Fare::MAX)
  end

  it "user should at least have the minimum fare in balance to check in to a station" do
    topup_amount = 3.0
    user.top_up(amount: topup_amount)

    station = "holborn"
    user.check_in(station: station)

    user.travel_to(station: "earls_court")
    expect(user.balance).to eq(0)
  end

  it "if the user has a balance which is less than the fare, they should be refused entry" do
    topup_amount = 2.0
    user.top_up(amount: topup_amount)

    station = "holborn"
    expect { user.check_in(station: station) }.to raise_error(StandardError, "You don't have the minimum fare required to check in")
  end
end
