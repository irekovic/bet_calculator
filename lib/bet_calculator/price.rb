module BetCalculator
	class Price
		attr_reader :price, :place_reduction
		def initialize(price, place_reduction)
			@price, @place_reduction = price.to_f, place_reduction.to_f
		end

		def to_f
			return @price
		end
	end
end
