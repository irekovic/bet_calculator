require 'bet_calculator'

ERROR_TOLERANCE = 0.005

Given(/^an? "([^"]*)" bet with stake "([^"]*)" on "([^"]*)"$/) do |type, stake, prices|
  @bet = Object::const_get("BetCalculator::#{type}").new stake, prices.split(/,/).map { |p| BetCalculator::Price.new p, 1 }
end

Given(/^a "([^"]*)" bet with stake "([^"]*)" on "([^"]*)" with place reduction "([^"]*)"$/) do |type, stake, prices, reduction_factor|
  @bet = Object::const_get("BetCalculator::#{type}").new stake, prices.split(/,/).map { |p| BetCalculator::Price.new p, reduction_factor }, true
end

When(/^I calculate a bet$/) do
	@calculation_result = BetCalculator.calculate @bet
end

Then(/^unit_stake should be "([^"]*)"$/) do |unit_stake|
  expect(@calculation_result[:unit_stake]).to be_within(ERROR_TOLERANCE).of(unit_stake.to_f)
end

Then(/^number_of_bets should be "([^"]*)"$/) do |number_of_bets|
  expect(@calculation_result[:number_of_bets]).to eq(number_of_bets.to_i)
end

Then(/^total_stake should be "([^"]*)"$/) do |stake|
  expect(@calculation_result[:total_stake]).to be_within(ERROR_TOLERANCE).of(stake.to_f)
end

Then(/^total_return should be "([^"]*)"$/) do |potential_return|
	expect(@calculation_result[:total_return]).to be_within(ERROR_TOLERANCE).of(potential_return.to_f)
end

Then(/^total_profit should be "([^"]*)"$/) do |profit|
  expect(@calculation_result[:total_profit]).to be_within(ERROR_TOLERANCE).of(profit.to_f)
end


