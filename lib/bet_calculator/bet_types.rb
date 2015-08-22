module BetCalculator

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
			Enumerator.new do |y|
				@prices.combination(3).each do |prices|
					prices.combination(2).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class Yankee < BetType
		def bets
			Enumerator.new do |y|
					@prices.combination(4).each do |prices| 
						prices.combination(2).each do |combination|
							y << MultipleBet.new(@stake, combination)
						end
						prices.combination(3).each do |combination|
							y << MultipleBet.new(@stake, combination)
						end
						y << MultipleBet.new(@stake, prices) 
					end
			end
		end
	end

	class Canadian < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(5).each do |prices| 
					prices.combination(2).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4).each do |combination|
						y << MultipleBet.new(@stake, combination) 
					end
					y << MultipleBet.new(@stake, prices) 
				end
			end
		end
	end


	class Heinz < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(6).each do |prices|
					prices.combination(2).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4).each do |combination|
						y << MultipleBet.new(@stake, combination) 
					end
					prices.combination(5).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end	 
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class SuperHeinz < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(7).each do |prices|
					prices.combination(2).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4).each do |combination|
						y << MultipleBet.new(@stake, combination) 
					end
					prices.combination(5).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end	 
					prices.combination(6).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class Goliath < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(8).each do |prices|
					prices.combination(2).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4).each do |combination|
						y << MultipleBet.new(@stake, combination) 
					end
					prices.combination(5).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end	 
					prices.combination(6).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(7).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end


	class Block < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(9).each do |prices|
					prices.combination(2).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4).each do |combination|
						y << MultipleBet.new(@stake, combination) 
					end
					prices.combination(5).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end	 
					prices.combination(6).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(7).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(8).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class Patent < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(3) do |prices|
					prices.each do |price|
						y << SingleBet.new(@stake, price)
					end 
					prices.combination(2) do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class Yap < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(4) do |prices|
					prices.each do |price|
						y << SingleBet.new(@stake, price)
					end 
					prices.combination(2) do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3) do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class Lucky15 < Yap 
	end

	class Lucky31 < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(5) do |prices|
					prices.each do |price|
						y << SingleBet.new(@stake, price)
					end 
					prices.combination(2) do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3) do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4) do |combination|
						y << MultipleBet.new(@stake, combination)
					end	
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class Lucky63 < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(6) do |prices|
					prices.each do |price|
						y << SingleBet.new(@stake, price)
					end 
					prices.combination(2) do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3) do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4) do |combination|
						y << MultipleBet.new(@stake, combination)
					end	
					prices.combination(5) do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class SuperHeinzWithSingles < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(7).each do |prices|
					prices.each do |price|
						y << SingleBet.new(@stake, price)
					end
					prices.combination(2).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4).each do |combination|
						y << MultipleBet.new(@stake, combination) 
					end
					prices.combination(5).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end	 
					prices.combination(6).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class GoliathWithSingles < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(8).each do |prices|
					prices.each do |p| 
						y << SingleBet.new(@stake, p)
					end
					prices.combination(2).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4).each do |combination|
						y << MultipleBet.new(@stake, combination) 
					end
					prices.combination(5).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end	 
					prices.combination(6).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(7).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
		end
	end

	class BlockWithSingles < BetType
		def bets
			Enumerator.new do |y|
				@prices.combination(9).each do |prices|
					prices.each do |p| 
						y << SingleBet.new(@stake, p) 
					end
					prices.combination(2).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(3).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(4).each do |combination|
						y << MultipleBet.new(@stake, combination) 
					end
					prices.combination(5).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end	 
					prices.combination(6).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(7).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					prices.combination(8).each do |combination|
						y << MultipleBet.new(@stake, combination)
					end
					y << MultipleBet.new(@stake, prices)
				end
			end
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

	class UnionJackTreble < BetType
		def bets
			Enumerator.new do |y|
				Accumulator.new(@stake, @prices.values_at(0,1,2)).bets.each { |e| y << e }
				Accumulator.new(@stake, @prices.values_at(3,4,5)).bets.each { |e| y << e }
				Accumulator.new(@stake, @prices.values_at(6,7,8)).bets.each { |e| y << e }
				Accumulator.new(@stake, @prices.values_at(0,3,6)).bets.each { |e| y << e }
				Accumulator.new(@stake, @prices.values_at(1,4,7)).bets.each { |e| y << e }
				Accumulator.new(@stake, @prices.values_at(2,5,8)).bets.each { |e| y << e }
				Accumulator.new(@stake, @prices.values_at(0,4,8)).bets.each { |e| y << e }
				Accumulator.new(@stake, @prices.values_at(2,4,6)).bets.each { |e| y << e }
			end
		end
	end

	class UnionJackTrixie < BetType
		def bets
			Enumerator.new do |y|
				Trixie.new(@stake, @prices.values_at(0,1,2)).bets.each { |e| y << e }
				Trixie.new(@stake, @prices.values_at(3,4,5)).bets.each { |e| y << e }
				Trixie.new(@stake, @prices.values_at(6,7,8)).bets.each { |e| y << e }
				Trixie.new(@stake, @prices.values_at(0,3,6)).bets.each { |e| y << e }
				Trixie.new(@stake, @prices.values_at(1,4,7)).bets.each { |e| y << e }
				Trixie.new(@stake, @prices.values_at(2,5,8)).bets.each { |e| y << e }
				Trixie.new(@stake, @prices.values_at(0,4,8)).bets.each { |e| y << e }
				Trixie.new(@stake, @prices.values_at(2,4,6)).bets.each { |e| y << e }
			end
		end
	end

	class UnionJackPatent < BetType
		def bets
			Enumerator.new do |y|
				Patent.new(@stake, @prices.values_at(0,1,2)).bets.each { |e| y << e }
				Patent.new(@stake, @prices.values_at(3,4,5)).bets.each { |e| y << e }
				Patent.new(@stake, @prices.values_at(6,7,8)).bets.each { |e| y << e }
				Patent.new(@stake, @prices.values_at(0,3,6)).bets.each { |e| y << e }
				Patent.new(@stake, @prices.values_at(1,4,7)).bets.each { |e| y << e }
				Patent.new(@stake, @prices.values_at(2,5,8)).bets.each { |e| y << e }
				Patent.new(@stake, @prices.values_at(0,4,8)).bets.each { |e| y << e }
				Patent.new(@stake, @prices.values_at(2,4,6)).bets.each { |e| y << e }
			end
		end
	end

	class UnionJackRoundRobin < BetType
		def bets
			Enumerator.new do |y|
				RoundRobin.new(@stake, @prices.values_at(0,1,2)).bets.each { |e| y << e }
				RoundRobin.new(@stake, @prices.values_at(3,4,5)).bets.each { |e| y << e }
				RoundRobin.new(@stake, @prices.values_at(6,7,8)).bets.each { |e| y << e }
				RoundRobin.new(@stake, @prices.values_at(0,3,6)).bets.each { |e| y << e }
				RoundRobin.new(@stake, @prices.values_at(1,4,7)).bets.each { |e| y << e }
				RoundRobin.new(@stake, @prices.values_at(2,5,8)).bets.each { |e| y << e }
				RoundRobin.new(@stake, @prices.values_at(0,4,8)).bets.each { |e| y << e }
				RoundRobin.new(@stake, @prices.values_at(2,4,6)).bets.each { |e| y << e }
			end
		end
	end

end
