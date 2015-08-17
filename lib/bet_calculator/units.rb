module BetCalculator
	class WinOnlyCalculator < Enumerator
		def initialize bet
			@bet = bet
		end

		def units
			@bet.visit self
		end

		def single
			Enumerator.new do |y|
				y.yield Unit.new @bet.stake, @bet.max_return
			end
		end

		def multiple
			Enumerator.new do |y|
				y.yield Unit.new @bet.stake, @bet.max_return
			end
		end

		def conditional
			Enumerator.new do |y|
				y.yield Unit.new @bet.stake, @bet.max_return
			end
		end
	end
	
	class Unit
		attr_reader :stake, :max_return
		def initialize(stake, max_return)
			@stake = stake
			@max_return = max_return
		end
	end
end
