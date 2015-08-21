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

		def conditional(conditional_bet)
			Enumerator.new do |y|
				first, *rest = *conditional_bet.bets
				rollover = 0.0
				_return  = calculate(conditional_bet.stake, first)

				rest.each do |bet|
					break unless _return > 0
					stake = [_return, conditional_bet.max_stake].min
					rollover += _return - stake
					_return   = calculate(stake, bet)
				end

				y << Unit.new(conditional_bet.stake, _return + rollover)
			end
		end

		def calculate(stake, bet)
			return stake * bet.price if bet.is_a? BetCalculator::SingleBet
			return stake * bet.legs.map(&:price).reduce(1, :*)
		end
	end
	
	class EachWayCalculator
		def initialize(options = {})
			defaults = { multiples_formula: :w2wp2p, atc_formula: :eq_div }
			effective_values = defaults.merge options
			@multiples_formula = effective_values[:multiples_formula]
			@atc_formula = effective_values[:atc_formula]
		end

		def single(bet)
			Enumerator.new do |y|
				y << Unit.new(bet.stake, bet.stake * bet.price)
				y << Unit.new(bet.stake, bet.stake * bet.place_price)
			end
		end

		def multiple(bet)
			Enumerator.new do |y|
				win_return, place_return = calculate(bet.stake, bet.stake, bet)
				y << Unit.new(bet.stake, win_return)
				y << Unit.new(bet.stake, place_return)
			end
		end

		def conditional(bet)
			Enumerator.new do |y|
				first, *rest = *bet.bets
				rollover   = 0.0
				win_return, place_return = calculate(bet.stake, bet.stake, first)

				rest.each do |b|
					stake   = [2 * bet.max_stake, win_return + place_return ].min
					rollover   += win_return + place_return - stake
					win_stake, place_stake = conditionals_split(bet.max_stake, stake)
					win_return, place_return = calculate(win_stake, place_stake, b)
				end

				y << Unit.new(bet.stake, win_return   + rollover / 2)
				y << Unit.new(bet.stake, place_return + rollover / 2)
			end
		end

		private 
			def calculate(win_stake, place_stake, bet)
				return win_stake * bet.price, place_stake * bet.place_price if bet.is_a? BetCalculator::SingleBet
				win_return = 0.0
				place_return = 0.0

				bet.legs.each do |leg|
					win_return = win_stake * leg.price
					place_return = place_stake * leg.place_price
					
					win_stake, place_stake = multiples_split win_return, place_return
				end

				return win_return, place_return
			end

			def conditionals_split(max_stake, funds)
				case @atc_formula
				when :eq_div
					half = funds / 2
					return half, half
				else
					win_stake = [max_stake, funds].min
					return win_stake, funds - win_stake
				end
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
