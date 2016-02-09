module BetCalculator

  class LegPart
    attr_reader :void
    def initialize(price, won = 1.0, void = 0.0)
      raise "Price must be positive" unless price.to_f > 0
      @price = price.to_f
      @won = won.to_f
      @void = void.to_f
      result = @won + @void
      raise "win + void percent must be <= 1.0 and >= 0" unless 0 <= result and result <= 1.0
    end

    def won
      @price * @won
    end

    def as_leg_part
      self
    end
  end

  class Leg
    attr_reader :win_part, :place_part

    def initialize(win_part, place_part = nil)
      @win_part = win_part.as_leg_part
      @place_part = place_part.as_leg_part if place_part
    end
  end

  class Bet
    def units(calculator)
      raise "You have to implement #{self.class}units(calculator) method in a bet"
    end
  end

  class AccumulatorBet < Bet
    attr_reader :stake, :legs
    def initialize(stake, prices)
      @stake = stake.to_f
      if prices.respond_to?(:to_a)
        @legs = prices.to_a
      else
        @legs = [prices]
      end
      # raise "You need more than 1 leg for multiple (#{@legs.size})" unless @legs.size > 1
    end

    def units(calculator)
      calculator.multiple self
    end
  end

  class ConditionalBet < Bet
    attr_reader :stake, :max_stake, :bets

    def initialize(stake, max_stake, bets)
      @stake = stake.to_f
      @max_stake = max_stake.to_f
      @bets = bets
    end


    def units(calculator)
      calculator.conditional self
    end
  end
end
