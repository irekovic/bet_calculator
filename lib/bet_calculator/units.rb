module BetCalculator
	class Unit
		attr_reader :stake
		def initialize(stake, price)
			@stake = stake.to_f
			@price = price.to_f
		end

		def max_return
			@stake * @price
		end
	end

	class ConditionalUnit
		attr_reader :stake
		def initialize(stake, max_stake, first, second)
			@stake = stake.to_f
			@max_stake = max_stake.to_f
			@first = first.to_f
			@second = second.to_f
		end

		def max_return
			result = @stake * @first
			sure_win = 0
			if (result > 0)
				stake = [result, @max_stake].min
				sure_win += result - stake
				result = stake * @second
			end

			result + sure_win
		end
	end
end
