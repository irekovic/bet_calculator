module BetCalculator

  class Result
    def self.won
      self.new 1, 0
    end

    attr_reader :won, :void
    def initialize(win_percent, void_percent)
      @won  = win_percent.to_f
      @void = void_percent.to_f
      raise "win + void percent must be <= 1.0" unless @won + @void <= 1.0
    end

    def as_result
      self
    end
  end

  class Leg
    attr_reader :price, :place_reduction, :win_result, :place_result

    def initialize(price, place_reduction = 1.0, win_result = Result.won, place_result = Result.won)
      raise IllegalArgument unless place_reduction.to_f > 0 and place_reduction.to_f <= 1
      raise IllegalArgument unless price.to_f > 0
      @price             = price.to_f
      @place_reduction   = place_reduction.to_f
      @win_result   = win_result.as_result
      @place_result = place_result.as_result
    end

    def place_price
      to_price(to_odd(@price) * @place_reduction)
    end

    def to_f
      return @price
    end

    private
      def to_price(odd)
        odd.to_f + 1.0
      end

      def to_odd(price)
        price.to_f - 1.0
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

    def place_price
      @leg.place_price
    end

    def win_result
      @leg.win_result
    end

    def place_result
      @leg.place_result
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
