module BetCalculator
  class Unit
    include Comparable

    attr_reader :stake, :max_return
    def initialize(stake, max_return)
      @stake = stake.to_f
      @max_return = max_return.to_f
    end

    def <=>(other)
      if @max_return > other.max_return
        +1
      elseif @max_return < other.max_return
        -1
      elseif @stake < other.stake
        +1
      elseif @stake > other.stake
        -1
      else
        0
      end
    end
  end

  class WinOnlyCalculator
    def single(bet)
      Enumerator.new do |y|
        win_return = calculate(bet.stake, bet)
        y << Unit.new(bet.stake, win_return)
      end
    end

    def multiple(bet)
      Enumerator.new do |y|
        win_return = calculate(bet.stake, bet)
        y. << Unit.new(bet.stake, win_return)
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
      return stake * bet.win_part.void + stake * bet.win_part.won if bet.is_a? BetCalculator::SingleBet
        _return = 0

        bet.legs.each do |leg|
          _return = stake * leg.win_part.void + stake * leg.win_part.won
          stake = _return
        end
        _return
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
        win_return, place_return = calculate(bet.stake, bet.stake, bet)
        y << Unit.new(bet.stake, win_return)
        y << Unit.new(bet.stake, place_return)      
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
          win_stake, place_stake = split_conditionals_return(bet.max_stake, stake)
          win_return, place_return = calculate(win_stake, place_stake, b)
        end

        y << Unit.new(bet.stake, win_return   + rollover / 2)
        y << Unit.new(bet.stake, place_return + rollover / 2)
      end
    end

    private 
      def calculate(win_stake, place_stake, bet)
        return win_stake   * bet.win_part.void   + win_stake   * bet.win_part.won, 
               place_stake * bet.place_part.void + place_stake * bet.place_part.won if bet.is_a? BetCalculator::SingleBet

        win_return = 0.0
        place_return = 0.0

        bet.legs.each do |leg|
          win_return   = win_stake   * leg.win_part.void   + win_stake   * leg.win_part.won
          place_return = place_stake * leg.place_part.void + place_stake * leg.place_part.won
          
          win_stake, place_stake = split_multiples_return(win_return, place_return)
        end

        return win_return, place_return
      end

      def split_conditionals_return(max_stake, funds)
        case @atc_formula
        when :eq_div
          half = funds / 2
          return half, half
        else
          win_stake = [max_stake, funds].min
          return win_stake, funds - win_stake
        end
      end

      def split_multiples_return(win, place)
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
