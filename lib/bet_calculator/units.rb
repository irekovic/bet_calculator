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
				stake = bet.stake
				_return = 0

				bet.legs.each do |leg|
					_return = stake * leg.price
					stake = _return
				end
				y << Unit.new(bet.stake, _return)
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
				winStake = bet.stake
				placeStake = bet.stake

				winReturn = 0.0
				placeReturn = 0.0

				bet.legs.each do |leg|
					winReturn = winStake * leg.price
					placeReturn = placeStake * leg.place_price
					winStake = winReturn
					placeStake = placeReturn
				end

				y << Unit.new(bet.stake, winReturn)
				y << Unit.new(bet.stake, placeReturn)
			end
		end

		def conditional(bet)
			raise "Not yet implemented each way calculation over conditional bets"
			Enumerator.new do |y|
			end
		end
	end
end
