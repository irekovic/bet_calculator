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
		def initialize(options = {})
			defaults = { multiples_formula: :w2w_p2p, atc_formula: :eq_div }
			effective_values = defaults.merge options
			@multiples_formula = effective_values[:multiples_formula]
			@atc_formula = effective_values[:atc_formula]
			# puts "@multiples_formula = #{@multiples_formula}, @atc_formula = #{@atc_formula}"
			# p @multiples_formula
			# p @atc_formula
		end

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
				rollover   = 0.0
				win_return, place_return = accumulate(bet.stake, bet.stake, first.legs)

				rest.each do |b|
					total_return = win_return + place_return
					stake = [total_return, bet.max_stake * 2].min
					rollover += total_return - stake
					stake /= 2
					win_return, place_return = accumulate(stake, stake, b.legs)
				end

				half_of_rollover = rollover / 2
				y << Unit.new(bet.stake, win_return + half_of_rollover)
				y << Unit.new(bet.stake, place_return + half_of_rollover)
			end
		end

		private 
			def accumulate(win_stake, place_stake, legs)
				win_return = 0.0
				place_return = 0.0

				legs.each do |leg|
					win_return = win_stake * leg.price
					place_return = place_stake * leg.place_price
					
					win_stake, place_stake = multiples_split win_return, place_return
				end

				return win_return, place_return
			end

			def multiples_split(win, place)
				case @multiples_formula
				when :eq_div
					half = (win + place) / 2
					return half, half
				else
					return win, place
				end
			end
	end
end
