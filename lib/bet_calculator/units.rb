module BetCalculator
	class Unit
		attr_reader :stake, :max_return
		def initialize(stake, max_return)
			@stake = stake
			@max_return = max_return
		end
	end

	class WinOnlyCalculator
		def single(bet)
			Enumerator.new do |y|
				y.yield Unit.new bet.stake, bet.stake * bet.price
			end
		end

		def multiple(bet)
			Enumerator.new do |y|
				y.yield Unit.new bet.stake, bet.stake * bet.legs.map(&:price).reduce(1, :*)
			end
		end

		def conditional(bet)
			Enumerator.new do |y|
				y.yield Unit.new bet.stake, bet.max_return
			end
		end
	end
	
	class EachWayCalculator
		def single(bet)
			Enumerator.new do |y|
				y << Unit.new(bet.stake, bet.stake * bet.price)
				y << Unit.new(bet.stake, bet.stake * bet.place_price)
			end
		end

		def multiple(bet)
			Enumerator.new do |y|
				y << Unit.new(bet.stake, bet.stake * bet.legs.map(&:price).reduce(1, :*))
				y << Unit.new(bet.stake, bet.stake * bet.legs.map(&:place_price).reduce(1, :*))
			end
		end

		def conditional(bet)
			Enumerator.new do |y|
			end
		end
	end
end
