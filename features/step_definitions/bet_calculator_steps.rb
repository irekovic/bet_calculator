require 'bet_calculator'

ERROR_TOLERANCE = 0.005

def place_price(win_price, reduction)
  ((win_price.to_f - 1.0) * reduction.to_f) + 1.0
end

Given(/^an? "([^"]*)" bet with stake "([^"]*)" on "([^"]*)"$/) do |type, stake, prices|
  clazz = Object::const_get("BetCalculator::#{type}")
  legs = prices.split(/,/).map do |price|
    BetCalculator::Leg.new BetCalculator::LegPart.new(price, 1, 0)
  end

  @bet = clazz.new stake, legs
end

Given(/^the "([^"]*)" bet type with stake "([^"]*)" on legs?:$/) do |type, stake, legs|
  # table is a Cucumber::Core::Ast::DataTable
  clazz = Object::const_get("BetCalculator::#{type}")

  header, *rows = *legs.raw

  legs = rows.map do |row|
    case row.size
    when 3
      BetCalculator.leg(*row)
    else
      BetCalculator.ew_leg(*row)
    end
  end

  @bet = clazz.new stake, legs
end

Given(/^an? "([^"]*)" bet with stake "([^"]*)" on "([^"]*)" with place reduction "([^"]*)"$/) do |type, stake, prices, reduction_factors|
  factors = reduction_factors.split(/,/).each.cycle
  clazz = Object::const_get("BetCalculator::#{type}")
  legs = prices.split(/,/).map do |price|
    BetCalculator::Leg.new BetCalculator::LegPart.new(price, 1, 0), BetCalculator::LegPart.new(((price.to_f - 1.0) * reduction_factors.to_f) + 1.0, 1, 0)
  end

  @bet = clazz.new stake, legs
end


When(/^I calculate the bet$/) do
  @calculation_result = BetCalculator.calculate @bet, BetCalculator::WinOnlyCalculator.new
end

When(/^I calculate each\-way bet with accumulators settled as "([^"]*)" and atc settled as "([^"]*)"$/) do |multiples_formula, atc_formula|
  @calculation_result = BetCalculator.calculate @bet, 
    BetCalculator::EachWayCalculator.new(multiples_formula: multiples_formula.to_sym, atc_formula: atc_formula.to_sym)
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


