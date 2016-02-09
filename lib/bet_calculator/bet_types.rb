module BetCalculator

  class BetType
    def initialize(stake, legs)
      @stake = stake.to_f
      @legs = legs.to_a
    end

    def bets
      raise "You have to implement #{self.class}#bets and return enumeration of bets from it"
    end
    
    def valid?
      return false unless respond_to?(:min_legs)
      return (min_legs..max_legs).include? @legs.size if respond_to?(:max_legs)
      return @legs.size == min_legs
    end

    private
      def full_cover(stake, count, legs)
        Enumerator.new do |y|
          legs.combination(count).each do |chosen_legs|
            (2..count).each do |fold|
              chosen_legs.combination(fold).each do |folded_legs|
                y << AccumulatorBet.new(stake, folded_legs)
              end
            end
          end
        end
      end

      def full_cover_with_singles(stake, count, legs)
        Enumerator.new do |y|
          legs.combination(count) do |legs|
            legs.each do |leg|
              y << AccumulatorBet.new(stake, leg)
            end 
            full_cover(stake, count, legs).each { |bet| y << bet }
          end
        end
      end

      def union_jack(elements)
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
  end

  class Single < BetType
    def min_legs
      1
    end

    def max_legs
      20
    end

    def bets
      Enumerator.new do |y|
        @legs.each do |leg|
          y << AccumulatorBet.new(@stake, leg)
        end
      end
    end
  end

  class Double < BetType
    def bets
      Enumerator.new do |y|
        @legs.combination(2) do |legs|
          y << AccumulatorBet.new(@stake, legs)
        end
      end
    end
  end

  class Treble < BetType
    def bets
      Enumerator.new do |y|
        @legs.combination(3) do |legs|
          y << AccumulatorBet.new(@stake, legs)
        end
      end
    end
  end

  class Accumulator < BetType
    def initialize(stake, legs, fold = legs.size)
      super stake, legs
      @fold = fold
    end

    def bets
      Enumerator.new do |y|
        @legs.combination(@fold) do |legs|
          y << AccumulatorBet.new(@stake, legs)
        end
      end
    end
  end

  class Trixie < BetType
    def bets
      full_cover(@stake, 3, @legs)
    end
  end

  class Yankee < BetType
    def bets
      full_cover(@stake, 4, @legs)
    end
  end

  class Canadian < BetType
    def bets
      full_cover(@stake, 5, @legs)
    end
  end


  class Heinz < BetType
    def bets
      full_cover(@stake, 6, @legs)
    end
  end

  class SuperHeinz < BetType
    def bets
      full_cover(@stake, 7, @legs)
    end
  end

  class Goliath < BetType
    def bets
      full_cover(@stake, 8, @legs)
    end
  end


  class Block < BetType
    def bets
      full_cover(@stake, 9, @legs)
    end
  end

  class Patent < BetType
    def bets
      full_cover_with_singles(@stake, 3, @legs)
    end
  end

  class Yap < BetType
    def bets
      full_cover_with_singles @stake, 4, @legs
    end
  end

  class Lucky15 < Yap 
  end

  class Lucky31 < BetType
    def bets
      full_cover_with_singles @stake, 5, @legs
    end
  end

  class Lucky63 < BetType
    def bets
      full_cover_with_singles @stake, 6, @legs
    end
  end

  class SuperHeinzWithSingles < BetType
    def bets
      full_cover_with_singles @stake, 7, @legs
    end
  end

  class GoliathWithSingles < BetType
    def bets
      full_cover_with_singles @stake, 8, @legs
    end
  end

  class BlockWithSingles < BetType
    def bets
      full_cover_with_singles @stake, 9, @legs
    end
  end

  class SingleStakesAbout < BetType
    def bets
      Enumerator.new do |y|
        @legs.permutation(2) do |legs|
          first, second = *legs
          y << ConditionalBet.new(@stake, @stake, [AccumulatorBet.new(0, first), AccumulatorBet.new(0, second)])
        end
      end
    end
  end

  class DoubleStakesAbout < BetType
    def bets
      Enumerator.new do |y|
        @legs.permutation(2) do |legs|
          first, second = *legs
          y << ConditionalBet.new(@stake, @stake * 2, [AccumulatorBet.new(0, first), AccumulatorBet.new(0, second)])
        end
      end
    end
  end

  class RoundRobin < BetType
    def bets
      Enumerator.new do |y|
        @legs.combination(3) do |legs|
          Trixie.new(@stake, legs).bets.each { |e| y << e }
          SingleStakesAbout.new(@stake, legs).bets.each { |e| y << e }
        end
      end
    end
  end

  class Flag < BetType
    def bets
      Enumerator.new do |y|
        Yankee.new(@stake, @legs).bets.each { |e| y << e }
        SingleStakesAbout.new(@stake, @legs).bets.each { |e| y << e }
      end
    end
  end

  class SuperFlag < BetType
    def bets
      Enumerator.new do |y|
        Canadian.new(@stake, @legs).bets.each { |e| y << e }
        SingleStakesAbout.new(@stake, @legs).bets.each { |e| y << e }
      end
    end
  end

  class HeinzFlag < BetType
    def bets
      Enumerator.new do |y|
        Heinz.new(@stake, @legs).bets.each { |e| y << e }
        SingleStakesAbout.new(@stake, @legs).bets.each { |e| y << e }
      end
    end
  end

  class SuperHeinzFlag < BetType
    def bets
      Enumerator.new do |y|
        SuperHeinz.new(@stake, @legs).bets.each { |e| y << e }
        SingleStakesAbout.new(@stake, @legs).bets.each { |e| y << e }
      end
    end
  end

  class GoliathFlag < BetType
    def bets
      Enumerator.new do |y|
        Goliath.new(@stake, @legs).bets.each { |e| y << e }
        SingleStakesAbout.new(@stake, @legs).bets.each { |e| y << e }
      end
    end        
  end

  class Rounder < BetType
    def bets
      Enumerator.new do |y|
        @legs.each do |price|
          rest = @legs - [price]
          y << ConditionalBet.new(@stake, @stake, [AccumulatorBet.new(0, price), AccumulatorBet.new(0, rest)])
        end
      end
    end
  end

  class Roundabout < BetType
    def bets
      Enumerator.new do |y|
        @legs.each do |price|
          rest = @legs - [price]
          y << ConditionalBet.new(@stake, @stake * 2, [AccumulatorBet.new(0, price), AccumulatorBet.new(0, rest)])
        end
      end
    end
  end

  class Alphabet < BetType
    def bets
      Enumerator.new do |y|
        Patent.new(@stake, @legs[0..2]).bets.each { |e| y << e }
        Patent.new(@stake, @legs[3..5]).bets.each { |e| y << e }
        Yankee.new(@stake, @legs[1..4]).bets.each { |e| y << e }
        Accumulator.new(@stake, @legs, 6). bets.each { |e| y << e }
      end
    end
  end

  class UnionJackTreble < BetType
    def bets
      Enumerator.new do |y|
        union_jack(@legs).each do |legs| 
          Accumulator.new(@stake, legs, 3).bets.each { |e| y << e } 
        end
      end
    end
  end

  class UnionJackTrixie < BetType
    def bets
      Enumerator.new do |y|
        union_jack(@legs).each do |legs|
          Trixie.new(@stake, legs).bets.each { |e| y << e }
        end
      end
    end
  end

  class UnionJackPatent < BetType
    def bets
      Enumerator.new do |y|
        union_jack(@legs).each do |legs|
          Patent.new(@stake, legs).bets.each { |e| y << e }
        end
      end
    end
  end

  class UnionJackRoundRobin < BetType
    def bets
      Enumerator.new do |y|
        union_jack(@legs).each do |legs|
          RoundRobin.new(@stake, legs).bets.each { |e| y << e }
        end
      end
    end
  end
end
