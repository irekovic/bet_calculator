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
				first, *rest = *bet.bets
				rollover = 0.0
				_return  = first.with_stake(bet.stake).units(self).map(&:max_return).reduce(&:+)

				rest.each do |b|
					break unless _return > 0
					stake = [_return, bet.max_stake].min
					rollover += _return - stake
					_return   = b.with_stake(stake).units(self).map(&:max_return).reduce(&:+)
				end

				y << Unit.new(bet.stake, _return + rollover)
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
				win_return, place_return = accumulate(bet.stake, bet.stake, bet.legs)
				y << Unit.new(bet.stake, win_return)
				y << Unit.new(bet.stake, place_return)
			end
		end

		def conditional(bet)
			Enumerator.new do |y|
				first, *rest = *bet.bets
				win_rollover   = 0.0
				place_rollover = 0.0
				win_return, place_return = accumulate(bet.stake, bet.stake, first.legs)

				rest.each do |b|
					win_stake       = [win_return,   bet.max_stake].min
					place_stake     = [place_return, bet.max_stake].min

					win_rollover   += win_return   - win_stake
					place_rollover += place_return - place_stake

					win_return, place_return = accumulate(win_stake, place_stake, b.legs)
				end

				y << Unit.new(bet.stake, win_return + win_rollover)
				y << Unit.new(bet.stake, place_return + place_rollover)
			end
		end

		def accumulate(win_stake, place_stake, legs)
			win_return = 0.0
			place_return = 0.0

			legs.each do |leg|
				win_return = win_stake * leg.price
				place_return = place_stake * leg.place_price
				# this is the place where we can insert :w2wp2p or :equaly_divided
				win_stake = win_return
				place_stake = place_return
			end

			return win_return, place_return
		end
	end
end
