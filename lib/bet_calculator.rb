require 'bet_calculator/price'
require 'bet_calculator/units'
require 'bet_calculator/bets'
require 'bet_calculator/bet_types'

module BetCalculator
	def self.calculate bet_type, calculator = WinOnlyCalculator.new
		result = { 
			unit_stake:     0.0,
			number_of_bets:   0, 
			total_stake:    0.0, 
			total_return:   0.0,
			total_profit:   0.0 
		}
		
		bet_type.bets.lazy.each do |bet|
			bet.units(calculator).each do |unit|
				result[:number_of_bets] += 1
				result[:total_stake]    += unit.stake
				result[:total_return]   += unit.max_return
			end
		end

		result[:unit_stake]   = result[:total_stake] / result[:number_of_bets] unless result[:number_of_bets] <= 0
		result[:total_profit] = result[:total_return] - result[:total_stake]

		return result
	end
end
