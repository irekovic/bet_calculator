require 'bet_calculator'

describe BetCalculator::Single do

  describe "leg validation" do
    it "should not be valid if no legs given" do
      single = BetCalculator::Single.new 10, []
      expect(single).not_to be_valid
    end

    it "should be valid with one leg" do
      leg = double(BetCalculator::Leg)
      single = BetCalculator::Single.new 10, [leg]
      expect(single).to be_valid
    end

    it "should be valid with 20 legs" do
      legs = (1..20).each.map do |a|
        double(BetCalculator::Leg)
      end
      single = BetCalculator::Single.new 10, legs
      expect(single).to be_valid
    end

    it "should be invalid with 21 legs" do 
      legs = (1..21).each.map do 
        double(BetCalculator::Leg)
      end
      single = BetCalculator::Single.new 10, legs
      expect(single).not_to be_valid
    end
  end

  describe "unit generation" do
    it "correctly generates units" 
  end
end
