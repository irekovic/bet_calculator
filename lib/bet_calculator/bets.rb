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

	class Bet
	end

	class SingleBet < Bet
		attr_reader :stake
		def initialize(stake, leg)
			raise "You need a Leg and not #{leg.class} #{leg}" unless leg.kind_of? Leg
			@stake = stake.to_f
			@leg = leg 
		end

		def with_stake(stake=0)
			SingleBet.new stake, @leg
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

		def legs
			[@leg]
		end
	end

	class MultipleBet < Bet
		attr_reader :stake
		def initialize(stake, prices)
			@stake = stake.to_f
			raise "You need more than 1 leg for multiple (#{prices.size})" unless prices.size > 1
			@legs = prices
		end

		def with_stake(stake = 0)
			MultipleBet.new stake, @legs
		end

		def units(calculator)
			calculator.multiple self
		end

		def legs
			@legs.each
		end

	end

	class ConditionalBet < Bet
		attr_reader :stake, :max_stake, :bets

		def initialize(stake, max_stake, first, second)
			@stake = stake.to_f
			@max_stake = max_stake.to_f
			raise "You need Bet and not #{first.class} for first bet" unless first.is_a? Bet
			raise "You need Bet and not #{second.class} for second bet" unless first.is_a? Bet
			@bets = [first] << second
		end


		def units(calculator)
			calculator.conditional self
		end
	end
end
