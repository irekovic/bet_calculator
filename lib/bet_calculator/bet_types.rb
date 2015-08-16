module BetCalculator

	class Bet 
		include Enumerable
		def each
			raise "You have to implement each"
		end
	end

	class Single
		include Enumerable

		def initialize(stake, price, place_reduction = 1.0)
			@stake = stake.to_f
			@price = price[0].to_f
			@place_reduction = place_reduction.to_f
		end

		def each &block
			yield Unit.new @stake, @price
		end
	end

	class Accumulator
		include Enumerable

		def initialize(stake, prices)
			@stake = stake.to_f
			@prices = prices.map { |e| e.to_f }
		end

		def each 
			yield Unit.new @stake, @prices.reduce(1, :*)
		end
	end

	class Trixie
		include Enumerable

		def initialize(stake, prices)
			@stake = stake.to_f
			@prices = prices.collect &:to_f
		end

		def each
			@prices.combination(2).each do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
			@prices.combination(3).each do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end

	class Yankee < Trixie
		def each
			super
			@prices.combination(4).each do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end

	class Canadian < Yankee
		def each
			super
			@prices.combination(5).each do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end


	class Heinz < Canadian
		def each
			super
			@prices.combination(6).each do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end

	class SuperHeinz < Heinz
		def each
			super
			@prices.combination(7).each do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end

	class Goliath < SuperHeinz
		def each
			super
			@prices.combination(8).each do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end


	class Block < Goliath
		def each
			super
			@prices.combination(9).each do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end

	class Patent
		include Enumerable

		def initialize(stake, prices)
			@stake = stake.to_f
			@prices = prices.collect &:to_f
		end

		def each
			@prices.each do |price|
				yield Unit.new @stake, price
			end 
			@prices.combination(2) do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
			@prices.combination(3) do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end

	class Yap < Patent
		def each
			super
			@prices.combination(4) do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end

	class Lucky15 < Yap
	end

	class Lucky31 < Lucky15
		def each
			super
			@prices.combination(5) do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end

	class Lucky63 < Lucky31
		def each
			super
			@prices.combination(6) do |combination|
				yield Unit.new @stake, combination.reduce(1, :*)
			end
		end
	end

	class SuperHeinzWithSingles < SuperHeinz
		def each
			@prices.each { |price| yield Unit.new @stake, price }
			super
		end
	end

	class GoliathWithSingles < Goliath
		def each
			@prices.each { |p| yield Unit.new @stake, p }
			super
		end
	end

	class BlockWithSingles < Block
		def each
			@prices.each { |p| yield Unit.new @stake, p }
			super
		end
	end

	class SingleStakesAbout
		include Enumerable
		def initialize(stake, prices)
			@stake = stake.to_f
			@prices = prices.collect &:to_f
		end

		def each
			@prices.permutation(2) do |prices|
				yield ConditionalUnit.new @stake, @stake, prices[0], prices[1]
			end
		end
	end

	class DoubleStakesAbout < SingleStakesAbout
		def each
			@prices.permutation(2) do |prices|
				yield ConditionalUnit.new @stake, @stake * 2, prices[0], prices[1]
			end
		end
	end

	class RoundRobin < Trixie
		def each
			super
			@prices.permutation(2) do |prices|
				yield ConditionalUnit.new @stake, @stake, prices[0], prices[1]
			end
		end
	end

	class Flag < Yankee
		def each
			super
			@prices.permutation(2) do |prices|
				yield ConditionalUnit.new @stake, @stake, prices[0], prices[1]
			end
		end
	end

	class SuperFlag < Canadian
		def each
			super
			@prices.permutation(2) do |prices|
				yield ConditionalUnit.new @stake, @stake, prices[0], prices[1]
			end
		end
	end

	class HeinzFlag < Heinz
		def each
			super
			@prices.permutation(2) do |prices|
				yield ConditionalUnit.new @stake, @stake, prices[0], prices[1]
			end
		end
	end

	class SuperHeinzFlag < SuperHeinz
		def each
			super
			@prices.permutation(2) do |prices|
				yield ConditionalUnit.new @stake, @stake, prices[0], prices[1]
			end
		end
	end

	class GoliathFlag < Goliath
		def each
			super
			@prices.permutation(2) do |prices|
				yield ConditionalUnit.new @stake, @stake, prices[0], prices[1]
			end
		end				
	end

	class Rounder
		include Enumerable
		def initialize(stake, prices)
			@stake = stake.to_f
			@prices = prices.collect(&:to_f)
		end

		def each
			@prices.each do |price|
				rest = @prices - [price]
				unit = ConditionalUnit.new @stake, @stake, price, rest.inject(1, :*)
				yield unit
			end
		end
	end

	class Roundabout < Rounder
		def each
			@prices.each do |price|
				rest = @prices - [price]
				unit = ConditionalUnit.new @stake, @stake * 2, price, rest.inject(1, :*)
				yield unit
			end
		end
	end

	class Alphabet
		include Enumerable
		def initialize(stake, prices)
			@stake = stake.to_f
			@prices = prices.collect(&:to_f)
		end

		def each(&block)
			Patent.new(@stake, @prices[0...3]).each(&block)
			Patent.new(@stake, @prices[3...6]).each(&block)
			Yankee.new(@stake, @prices[1...5]).each(&block)
			Accumulator.new(@stake, @prices).each(&block)
		end
	end

	class UnionJackTreble
		include Enumerable
		def initialize(stake, prices)
			@stake = stake.to_f
			@prices = prices.collect(&:to_f)
		end

		def each(&block)
			Accumulator.new(@stake, @prices.values_at(0,1,2)).each(&block)
			Accumulator.new(@stake, @prices.values_at(3,4,5)).each(&block)
			Accumulator.new(@stake, @prices.values_at(6,7,8)).each(&block)
			Accumulator.new(@stake, @prices.values_at(0,3,6)).each(&block)
			Accumulator.new(@stake, @prices.values_at(1,4,7)).each(&block)
			Accumulator.new(@stake, @prices.values_at(2,5,8)).each(&block)
			Accumulator.new(@stake, @prices.values_at(0,4,8)).each(&block)
			Accumulator.new(@stake, @prices.values_at(2,4,6)).each(&block)
		end
	end

	class UnionJackTrixie < UnionJackTreble
		def each(&block)
			Trixie.new(@stake, @prices.values_at(0,1,2)).each(&block)
			Trixie.new(@stake, @prices.values_at(3,4,5)).each(&block)
			Trixie.new(@stake, @prices.values_at(6,7,8)).each(&block)
			Trixie.new(@stake, @prices.values_at(0,3,6)).each(&block)
			Trixie.new(@stake, @prices.values_at(1,4,7)).each(&block)
			Trixie.new(@stake, @prices.values_at(2,5,8)).each(&block)
			Trixie.new(@stake, @prices.values_at(0,4,8)).each(&block)
			Trixie.new(@stake, @prices.values_at(2,4,6)).each(&block)
		end
	end

	class UnionJackPatent < UnionJackTreble
		def each(&block)
			Patent.new(@stake, @prices.values_at(0,1,2)).each(&block)
			Patent.new(@stake, @prices.values_at(3,4,5)).each(&block)
			Patent.new(@stake, @prices.values_at(6,7,8)).each(&block)
			Patent.new(@stake, @prices.values_at(0,3,6)).each(&block)
			Patent.new(@stake, @prices.values_at(1,4,7)).each(&block)
			Patent.new(@stake, @prices.values_at(2,5,8)).each(&block)
			Patent.new(@stake, @prices.values_at(0,4,8)).each(&block)
			Patent.new(@stake, @prices.values_at(2,4,6)).each(&block)
		end
	end

	class UnionJackRoundRobin < UnionJackPatent
		def each(&block)
			RoundRobin.new(@stake, @prices.values_at(0,1,2)).each(&block)
			RoundRobin.new(@stake, @prices.values_at(3,4,5)).each(&block)
			RoundRobin.new(@stake, @prices.values_at(6,7,8)).each(&block)
			RoundRobin.new(@stake, @prices.values_at(0,3,6)).each(&block)
			RoundRobin.new(@stake, @prices.values_at(1,4,7)).each(&block)
			RoundRobin.new(@stake, @prices.values_at(2,5,8)).each(&block)
			RoundRobin.new(@stake, @prices.values_at(0,4,8)).each(&block)
			RoundRobin.new(@stake, @prices.values_at(2,4,6)).each(&block)
		end
	end

end
