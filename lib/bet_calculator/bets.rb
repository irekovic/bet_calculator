module BetCalculator
	class Leg
		attr_reader :price, :place_reduction
		def initialize(price, place_reduction = 1.0)
			raise IllegalArgument unless place_reduction.to_f > 0 and place_reduction.to_f <= 1
			raise IllegalArgument unless price.to_f > 0
			@price 						= price.to_f
			@place_reduction 	= place_reduction.to_f
		end

		def place_price
			to_price(to_odd(@price) * @place_reduction)
		end

		def to_f
			return @price
		end

		private
			def to_price(odd)
				odd.to_f + 1.0
			end

			def to_odd(price)
				price.to_f - 1.0
			end
	end

	class SingleBet
		attr_reader :stake
		def initialize(stake, leg)
			raise "You need a Leg and not #{leg.class} #{leg}" unless leg.kind_of? Leg
			@stake = stake.to_f
			@leg = leg 
		end

		def units(calculator)
			calculator.single self
		end

		def price
			@leg.price
		end

		def place_price
			@leg.place_price
		end
	end

	class MultipleBet
		attr_reader :stake
		def initialize(stake, prices)
			@stake = stake.to_f
			raise YouNeedMorePricesForMultiple unless prices.size > 1
			@legs = prices
		end

		def units(calculator)
			calculator.multiple self
		end

		def legs
			@legs.each
		end

	end

	class ConditionalBet
		attr_reader :stake
		def initialize(stake, max_stake, first, second)
			@stake = stake.to_f
			@max_stake = max_stake.to_f
			@first = first.to_f
			@second = second.collect(&:to_f).reduce(1,:*)
		end

		def units(calculator)
			calculator.conditional self
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
