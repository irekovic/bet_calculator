module BetCalculator
	class Leg
		attr_reader :price, :place_reduction
		def initialize(price, place_reduction = 1.0)
			raise IllegalArgument unless place_reduction.to_f > 0 and place_reduction.to_f <= 1
			raise IllegalArgument unless price.to_f > 0
			@price, @place_reduction = price.to_f, place_reduction.to_f
		end

		def to_f
			return @price
		end
	end

	class Bet
		def units
			return enum_for(:units) unless block_given?
			yield Unit.new @stake, max_return		
		end
	end 

	class SingleBet < Bet
		attr_reader :stake, :price
		def initialize(stake, price)
			@stake = stake.to_f
			@price = price.to_f
		end

		def max_return
			@stake * @price
		end
	end

	class MultipleBet < Bet
		attr_reader :stake
		def initialize(stake, prices)
			@stake = stake.to_f
			raise YouNeedMorePricesForMultiple unless prices.size > 1
			@prices = prices.collect(&:to_f)
		end

		def max_return
			@stake * @prices.reduce(1, :*)
		end
	end

	class ConditionalBet < Bet
		attr_reader :stake
		def initialize(stake, max_stake, first, second)
			@stake = stake.to_f
			@max_stake = max_stake.to_f
			@first = first.to_f
			@second = second.collect(&:to_f).reduce(1,:*)
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
