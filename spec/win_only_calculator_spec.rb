module BetCalculator
  describe WinOnlyCalculator do
    it "calculates singles correctly" do
      bet = AccumulatorBet.new(10, Leg.new(LegPart.new(10)))
      calculator = BetCalculator::WinOnlyCalculator.new  
      expect(calculator.single(bet).to_a).to contain_exactly Unit.new 10, 20
    end
  end
end
