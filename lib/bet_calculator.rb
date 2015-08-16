require 'bet_calculator/price'
require 'bet_calculator/units'
require 'bet_calculator/bet_types'

module BetCalculator
	def self.calculate bet
		result = { number_of_bets: 0, total_stake: 0, total_return: 0 }
		result = bet.reduce(result) do |result, unit|
			number_of_bets = result.fetch(:number_of_bets, 0)
			total_stake = result.fetch(:total_stake, 0.0)
			total_return = result.fetch(:total_return, 0.0)
			
			result[:number_of_bets] += 1
			result[:total_stake] = total_stake + unit.stake
			result[:total_return] = total_return + unit.max_return

			result
		end


		result[:unit_stake] = result[:number_of_bets] > 0 ? result[:total_stake] / result[:number_of_bets] : 0
		result[:total_profit] = result[:total_return] - result[:total_stake]

		return result
	end

	class EachWay
		def initialize(bet)
			@bet = bet
		end

		def stake
			@bet.stake * 2
		end

		def max_return
			stake = @bet.stake
			price = @bet.price
			place_reduction = @bet.place_reduction

			win_odds = price - 1
			place_odds = win_odds * place_reduction
			place_price = place_odds + 1
			win_part = stake * price
			place_part = stake * place_price
			return win_part + place_part
		end
	end
end
