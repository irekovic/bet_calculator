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
		
		bet_type.bets.each do |bet|
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

	# class EachWay
	# 	def initialize(bet)
	# 		@bet = bet
	# 	end

	# 	def stake
	# 		@bet.stake * 2
	# 	end

		# def single_each_way_units
		# 	stake = 10.00
		# 	price = 2.00
		# 	reduction = 0.20
		# 	yield Unit.new stake, price * stake
		# 	place_price = ((price - 1) * reduction) + 1
		# 	yield Unit.new stake, place_price * stake
		# end

		# def multiple_each_way_win_to_win_place_to_place
		# 	stake  = 10.00
		# 	prices = [2.00, 3.00]
		# 	reductions = [0.20, 0.20]
		# 	yield Unit.new stake, stake * prices.reduce(1, :*)

		# 	yield Unit.new stake, stake * prices.zip reductions do | price, reduction |
		# 		((price - 1) * reduction) + 1
		# 	end.reduce(1, :*)
		# end

		# def multiple_each_way_equaly_divided

		# end

		# def conditional_each_way_equaly_divided
		# end

		# def conditional_each_way_win_precedence
		# end

	# 	def max_return
	# 		stake = @bet.stake
	# 		price = @bet.price
	# 		place_reduction = @bet.place_reduction

	# 		win_odds = price - 1
	# 		place_odds = win_odds * place_reduction
	# 		place_price = place_odds + 1
	# 		win_part = stake * price
	# 		place_part = stake * place_price
	# 		return win_part + place_part
	# 	end
	# end
end
