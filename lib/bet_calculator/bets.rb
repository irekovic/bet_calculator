module BetCalculator

  class LegPart
    attr_reader :void
    def initialize(price, won = 1.0, void = 0.0)
      raise "Price must be positive" unless price.to_f > 0
      @price = price.to_f
      @won = won.to_f
      @void = void.to_f
      raise "win + void percent must be <= 1.0" unless @won + @void <= 1.0
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

  class SingleBet < Bet
    attr_reader :stake
    def initialize(stake, leg)
      @stake = stake.to_f
      @leg = leg 
    end

    def units(calculator)
      calculator.single self
    end

    def price
      @leg.price
    end

    def win_part
      @leg.win_part
    end

    def place_part
      @leg.place_part
    end
  end

  class MultipleBet < Bet
    attr_reader :stake, :legs
    def initialize(stake, prices)
      @stake = stake.to_f
      @legs = prices.to_a
      raise "You need more than 1 leg for multiple (#{@legs.size})" unless @legs.size > 1
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
