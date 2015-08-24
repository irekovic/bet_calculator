module BetCalculator

	def self.full_cover(stake, count, legs)
		Enumerator.new do |y|
			legs.combination(count).each do |prices|
				(2..count).each do |fold|
					prices.combination(fold).each do |combination|
						y << MultipleBet.new(stake, combination)
					end
				end
			end
		end
	end

	def self.full_cover_with_singles(stake, count, legs)
		Enumerator.new do |y|
			legs.combination(count) do |prices|
				prices.each do |price|
					y << SingleBet.new(stake, price)
				end 
				full_cover(stake, count, prices).each { |bet| y << bet }
			end
		end
	end

	class BetType
		def initialize(stake, legs)
			@stake = stake.to_f
			@prices = legs.to_a
		end

		def bets
			raise "You have to implement bets in #{self.class} and return enumeration of bets from it"
		end
	end

	class Single < BetType
		def bets
			Enumerator.new do |y|
				@prices.each do |leg|
					y << SingleBet.new(@stake, leg)
				end
			end
		end
	end

	class Accumulator < BetType
		def bets
			Enumerator.new do |y|
				y << MultipleBet.new(@stake, @prices)
			end
		end
	end

	class Trixie < BetType
		def bets
			BetCalculator.full_cover(@stake, 3, @prices)
		end
	end

	class Yankee < BetType
		def bets
			BetCalculator.full_cover(@stake, 4, @prices)
		end
	end

	class Canadian < BetType
		def bets
			BetCalculator.full_cover(@stake, 5, @prices)
		end
	end


	class Heinz < BetType
		def bets
			BetCalculator.full_cover(@stake, 6, @prices)
		end
	end

	class SuperHeinz < BetType
		def bets
			BetCalculator.full_cover(@stake, 7, @prices)
		end
	end

	class Goliath < BetType
		def bets
			BetCalculator.full_cover(@stake, 8, @prices)
		end
	end


	class Block < BetType
		def bets
			BetCalculator.full_cover(@stake, 9, @prices)
		end
	end

	class Patent < BetType
		def bets
			BetCalculator.full_cover_with_singles(@stake, 3, @prices)
		end
	end

	class Yap < BetType
		def bets
			BetCalculator.full_cover_with_singles @stake, 4, @prices
		end
	end

	class Lucky15 < Yap 
	end

	class Lucky31 < BetType
		def bets
			BetCalculator.full_cover_with_singles @stake, 5, @prices
		end
	end

	class Lucky63 < BetType
		def bets
			BetCalculator.full_cover_with_singles @stake, 6, @prices
		end
	end

	class SuperHeinzWithSingles < BetType
		def bets
			BetCalculator.full_cover_with_singles @stake, 7, @prices
		end
	end

	class GoliathWithSingles < BetType
		def bets
			BetCalculator.full_cover_with_singles @stake, 8, @prices
		end
	end

	class BlockWithSingles < BetType
		def bets
			BetCalculator.full_cover_with_singles @stake, 9, @prices
		end
	end

	class SingleStakesAbout < BetType
		def bets
			Enumerator.new do |y|
				@prices.permutation(2) do |prices|
					first, second = *prices
					y << ConditionalBet.new(@stake, @stake, [SingleBet.new(0, first), SingleBet.new(0, second)])
				end
			end
		end
	end

	class DoubleStakesAbout < BetType
		def bets
			Enumerator.new do |y|
				@prices.permutation(2) do |prices|
					first, second = *prices
					y << ConditionalBet.new(@stake, @stake * 2, [SingleBet.new(0, first), SingleBet.new(0, second)])
				end
			end
		end
	end

	class RoundRobin < Trixie
		def bets
			Enumerator.new do |y|
				@prices.combination(3) do |prices|
					Trixie.new(@stake, prices).bets.each { |e| y << e }
					SingleStakesAbout.new(@stake, prices).bets.each { |e| y << e }
				end
			end
		end
	end

	class Flag < BetType
		def bets
			Enumerator.new do |y|
				Yankee.new(@stake, @prices).bets.each { |e| y << e }
				SingleStakesAbout.new(@stake, @prices).bets.each { |e| y << e }
			end
		end
	end

	class SuperFlag < BetType
		def bets
			Enumerator.new do |y|
				Canadian.new(@stake, @prices).bets.each { |e| y << e }
				SingleStakesAbout.new(@stake, @prices).bets.each { |e| y << e }
			end
		end
	end

	class HeinzFlag < BetType
		def bets
			Enumerator.new do |y|
				Heinz.new(@stake, @prices).bets.each { |e| y << e }
				SingleStakesAbout.new(@stake, @prices).bets.each { |e| y << e }
			end
		end
	end

	class SuperHeinzFlag < BetType
		def bets
			Enumerator.new do |y|
				SuperHeinz.new(@stake, @prices).bets.each { |e| y << e }
				SingleStakesAbout.new(@stake, @prices).bets.each { |e| y << e }
			end
		end
	end

	class GoliathFlag < BetType
		def bets
			Enumerator.new do |y|
				Goliath.new(@stake, @prices).bets.each { |e| y << e }
				SingleStakesAbout.new(@stake, @prices).bets.each { |e| y << e }
			end
		end				
	end

	class Rounder < BetType
		def bets
			Enumerator.new do |y|
				@prices.each do |price|
					rest = @prices - [price]
					y << ConditionalBet.new(@stake, @stake, [SingleBet.new(0, price), MultipleBet.new(0, rest)])
				end
			end
		end
	end

	class Roundabout < BetType
		def bets
			Enumerator.new do |y|
				@prices.each do |price|
					rest = @prices - [price]
					y << ConditionalBet.new(@stake, @stake * 2, [SingleBet.new(0, price), MultipleBet.new(0, rest)])
				end
			end
		end
	end

	class Alphabet < BetType
		def bets
			Enumerator.new do |y|
				Patent.new(@stake, @prices[0..2]).bets.each { |e| y << e }
				Patent.new(@stake, @prices[3..5]).bets.each { |e| y << e }
				Yankee.new(@stake, @prices[1..4]).bets.each { |e| y << e }
				Accumulator.new(@stake, @prices). bets.each { |e| y << e }
			end
		end
	end

	def self.union_jack(elements)
		Enumerator.new do |y|
			y << elements.values_at(0,1,2)
			y << elements.values_at(3,4,5)
			y << elements.values_at(6,7,8)
			y << elements.values_at(0,3,6)
			y << elements.values_at(1,4,7)
			y << elements.values_at(2,5,8)
			y << elements.values_at(0,4,8)
			y << elements.values_at(2,4,6)
		end
	end

	class UnionJackTreble < BetType
		def bets
			Enumerator.new do |y|
				BetCalculator.union_jack(@prices).each do |legs| 
					Accumulator.new(@stake, legs).bets.each { |e| y << e } 
				end
			end
		end
	end

	class UnionJackTrixie < BetType
		def bets
			Enumerator.new do |y|
				BetCalculator.union_jack(@prices).each do |legs|
					Trixie.new(@stake, legs).bets.each { |e| y << e }
				end
			end
		end
	end

	class UnionJackPatent < BetType
		def bets
			Enumerator.new do |y|
				BetCalculator.union_jack(@prices).each do |legs|
					Patent.new(@stake, legs).bets.each { |e| y << e }
				end
			end
		end
	end

	class UnionJackRoundRobin < BetType
		def bets
			Enumerator.new do |y|
				BetCalculator.union_jack(@prices).each do |legs|
					RoundRobin.new(@stake, legs).bets.each { |e| y << e }
				end
			end
		end
	end

end
