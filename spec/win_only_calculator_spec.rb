module BetCalculator
	describe WinOnlyCalculator do
		it "calculates singles correctly" do
			bet = double("bet", stake: 10, price: 2)
			calculator = BetCalculator::WinOnlyCalculator.new	
			expect(calculator.single(bet).to_a).to contain_exactly Unit.new 10, 20
		end
	end
end
