Feature: Bet Calculation
	Calculator should correctly calculate various bet types

	Scenario Outline: calculating a bet
		Given a "<Bet Type>" bet with stake "<Stake>" on "<Prices>"
		When I calculate a bet
		Then number_of_bets should be "<Number of Bets>"
		And total_stake should be "<Total Stake>"
		And total_return should be "<Total Return>"
		And unit_stake should be "<Stake>"
		And total_profit should be "<Total Profit>"

		Examples: 
			|Bet Type             |Stake|Prices             |Number of Bets|Total Stake|Total Return  |Total Profit  |
			|Single               |10.00|1.2                |             1|      10.00|         12.00|          2.00|
			|Accumulator          |10.00|1.2,1.3            |             1|      10.00|         15.60|          5.60|
			|Accumulator          |10.00|1.2,1.3,2          |             1|      10.00|         31.20|         21.20|
			|Accumulator          |10.00|1.2,1.3,2,3        |             1|      10.00|         93.60|         83.60|
			|Trixie               |10.00|1.2,1.3,2          |             4|      40.00|         96.80|         56.80|
			|Yankee               |10.00|1.2,1.3,2,3        |            11|     110.00|        522.20|        412.20|
			|Canadian             |10.00|1.2,1.3,2,3,4      |            26|     260.00|      2_911.00|      2_651.00|
			|Heinz                |10.00|1.2,1.3,2,3,4,5    |            57|     570.00|     18_041.00|     17_471.00|
			|SuperHeinz           |10.00|1.2,1.3,2,3,4,5,6  |           120|   1_200.00|    127_277.00|    126_077.00|
			|Goliath              |10.00|1.2,1.3,2,3,4,5,6,7|           247|   2_470.00|  1_019_791.00|  1_017_321.00|
			|Block                |10.00|2,3,4,5,6,7,8,9,10 |           502|   5_020.00|199_583_450.00|199_578_430.00|
			|Patent               |10.00|1.2,1.3,1.4        |             7|      70.00|        111.44|         41.44|
			|Yap                  |10.00|2,3,4,5            |            15|     150.00|      3_590.00|      3_440.00|
			|Lucky15              |10.00|2,3,4,5            |            15|     150.00|      3_590.00|      3_440.00|
			|Lucky31              |10.00|2,3,4,5,6          |            31|     310.00|     25_190.00|     24_880.00|
			|Lucky63              |10.00|2,3,4,5,6,7        |            63|     630.00|    201_590.00|    200_960.00|
			|SuperHeinzWithSingles|10.00|2,3,4,5,6,7,8      |           127|   1_270.00|  1_814_390.00|  1_813_120.00|
			|GoliathWithSingles   |10.00|2,3,4,5,6,7,8,9    |           255|   2_550.00| 18_143_990.00| 18_141_440.00|
			|BlockWithSingles     |10.00|2,3,4,5,6,7,8,9,10 |           511|   5_110.00|199_583_990.00|199_578_880.00|
			|SingleStakesAbout    |10.00|2,3                |             2|      20.00|         80.00|         60.00|
			|DoubleStakesAbout    |10.00|2,3                |             2|      20.00|        110.00|         90.00|
			|RoundRobin           |10.00|2,3,4              |            10|     100.00|        800.00|        700.00|
			|Flag                 |10.00|2,3,4,5            |            23|     230.00|      4_170.00|      3_940.00|
			|SuperFlag            |10.00|2,3,4,5,6          |            46|     460.00|     26_390.00|     25_930.00|
			|HeinzFlag            |10.00|2,3,4,5,6,7        |            87|     870.00|    203_720.00|    202_850.00|
			|SuperHeinzFlag       |10.00|2,3,4,5,6,7,8      |           162|   1_620.00|  1_817_820.00|  1_816_200.00|
			|GoliathFlag          |10.00|2,3,4,5,6,7,8,9    |           303|   3_030.00| 18_149_150.00| 18_146_120.00|
			|Rounder              |10.00|2,3,4              |             3|      30.00|        320.00|        290.00|
			|Roundabout           |10.00|2,3,4              |             3|      30.00|        550.00|        520.00|
			|Alphabet             |10.00|2,3,4,5,6,7        |            26|     260.00|     62_550.00|     62_290.00|
			|UnionJackTreble      |10.00|2,3,4,5,6,7,8,9,10 |             8|      80.00|     17_880.00|     17_800.00|
			|UnionJackTrixie      |10.00|2,3,4,5,6,7,8,9,10 |            32|     320.00|     26_620.00|     26_300.00|
			|UnionJackPatent      |10.00|2,3,4,5,6,7,8,9,10 |            56|     560.00|     28_060.00|     27_500.00|
			|UnionJackRoundRobin  |10.00|2,3,4,5,6,7,8,9,10 |            80|     800.00|     31_900.00|     31_100.00|


	Scenario Outline: calculating an EachWay bet
		Given a "<bet_type>" bet with stake "<stake>" on "<price>" with place reduction "0.20"
		When I calculate each-way bet with accumulators settled as "<M_F>" and atc settled as "<ATC_F>"
		Then number_of_bets should be "<number_of_bets>"
		And total_stake should be "<total_stake>"
		And total_return should be "<total_return>"
		And unit_stake should be "<stake>"
		And total_profit should be "<total_profit>"

		Examples: 
			|bet_type             |stake|price              |E/W|M_F   |ATC_F |number_of_bets|total_stake|total_return  |total_profit  |
			|Single               |10.00|2                  |0.2|w2wp2p|eq_div|             2|      20.00|         32.00|         12.00|
			|Single               |10.00|2                  |0.2|w2wp2p|wprecd|             2|      20.00|         32.00|         12.00|
			|Single               |10.00|2                  |0.2|eq_div|eq_div|             2|      20.00|         32.00|         12.00|
			|Single               |10.00|2                  |0.2|eq_div|wprecd|             2|      20.00|         32.00|         12.00|
			|Accumulator          |10.00|1.2,1.3            |0.2|w2wp2p|eq_div|             2|      20.00|         26.62|          6.62|
			|Accumulator          |10.00|1.2,1.3            |0.2|w2wp2p|wprecd|             2|      20.00|         26.62|          6.62|
			|Accumulator          |10.00|1.2,1.3            |0.2|eq_div|eq_div|             2|      20.00|         26.43|          6.43|
			|Accumulator          |10.00|1.2,1.3            |0.2|eq_div|wprecd|             2|      20.00|         26.43|          6.43|
			|Accumulator          |10.00|1.2,1.3,2          |0.2|w2wp2p|eq_div|             2|      20.00|         44.43|         24.43|
			|Accumulator          |10.00|1.2,1.3,2          |0.2|w2wp2p|wprecd|             2|      20.00|         44.43|         24.43|
			|Accumulator          |10.00|1.2,1.3,2          |0.2|eq_div|eq_div|             2|      20.00|         42.29|         22.29|
			|Accumulator          |10.00|1.2,1.3,2          |0.2|eq_div|wprecd|             2|      20.00|         42.29|         22.29|
			|Accumulator          |10.00|1.2,1.3,2,3        |0.2|w2wp2p|eq_div|             2|      20.00|        112.12|         92.12|
			|Accumulator          |10.00|1.2,1.3,2,3        |0.2|w2wp2p|wprecd|             2|      20.00|        112.12|         92.12|
			|Accumulator          |10.00|1.2,1.3,2,3        |0.2|eq_div|eq_div|             2|      20.00|         93.04|         73.04|
			|Accumulator          |10.00|1.2,1.3,2,3        |0.2|eq_div|wprecd|             2|      20.00|         93.04|         73.04|
			|Trixie               |10.00|1.2,1.3,2          |0.2|w2wp2p|eq_div|             8|      80.00|        146.25|         66.25|
			|Trixie               |10.00|1.2,1.3,2          |0.2|w2wp2p|wprecd|             8|      80.00|        146.25|         66.25|
			|Trixie               |10.00|1.2,1.3,2          |0.2|eq_div|eq_div|             8|      80.00|        142.32|         62.32|
			|Trixie               |10.00|1.2,1.3,2          |0.2|eq_div|wprecd|             8|      80.00|        142.32|         62.32|
			|Yankee               |10.00|1.2,1.3,2,3        |0.2|w2wp2p|eq_div|            22|     220.00|        687.09|        467.09|
			|Yankee               |10.00|1.2,1.3,2,3        |0.2|w2wp2p|wprecd|            22|     220.00|        687.09|        467.09|
			|Yankee               |10.00|1.2,1.3,2,3        |0.2|eq_div|eq_div|            22|     220.00|        627.03|        407.03|
			|Yankee               |10.00|1.2,1.3,2,3        |0.2|eq_div|wprecd|            22|     220.00|        627.03|        407.03|
			|Canadian             |10.00|1.2,1.3,2,3,4      |0.2|w2wp2p|eq_div|            52|     520.00|      3_414.91|      2_894.91|
			|Canadian             |10.00|1.2,1.3,2,3,4      |0.2|w2wp2p|wprecd|            52|     520.00|      3_414.91|      2_894.91|
			|Canadian             |10.00|1.2,1.3,2,3,4      |0.2|eq_div|eq_div|            52|     520.00|      2_724.33|      2_204.33|
			|Canadian             |10.00|1.2,1.3,2,3,4      |0.2|eq_div|wprecd|            52|     520.00|      2_724.33|      2_204.33|
			|Heinz                |10.00|1.2,1.3,2,3,4,5    |0.2|w2wp2p|eq_div|           114|   1_140.00|     19_565.34|     18_425.34|
			|Heinz                |10.00|1.2,1.3,2,3,4,5    |0.2|w2wp2p|wprecd|           114|   1_140.00|     19_565.34|     18_425.34|
			|Heinz                |10.00|1.2,1.3,2,3,4,5    |0.2|eq_div|eq_div|           114|   1_140.00|     12_592.25|     11_452.25|
			|Heinz                |10.00|1.2,1.3,2,3,4,5    |0.2|eq_div|wprecd|           114|   1_140.00|     12_592.25|     11_452.25|
			|SuperHeinz           |10.00|1.2,1.3,2,3,4,5,6  |0.2|w2wp2p|eq_div|           240|   2_400.00|    132_012.01|    129_612.01|
			|SuperHeinz           |10.00|1.2,1.3,2,3,4,5,6  |0.2|w2wp2p|wprecd|           240|   2_400.00|    132_012.01|    129_612.01|
			|SuperHeinz           |10.00|1.2,1.3,2,3,4,5,6  |0.2|eq_div|eq_div|           240|   2_400.00|     63_945.26|     61_545.26|
			|SuperHeinz           |10.00|1.2,1.3,2,3,4,5,6  |0.2|eq_div|wprecd|           240|   2_400.00|     63_945.26|     61_545.26|
			|Goliath              |10.00|1.2,1.3,2,3,4,5,6,7|0.2|w2wp2p|eq_div|           494|   4_940.00|  1_035_165.22|  1_030_225.22|
			|Goliath              |10.00|1.2,1.3,2,3,4,5,6,7|0.2|w2wp2p|wprecd|           494|   4_940.00|  1_035_165.22|  1_030_225.22|
			|Goliath              |10.00|1.2,1.3,2,3,4,5,6,7|0.2|eq_div|eq_div|           494|   4_940.00|    359_593.07|    354_653.07|
			|Goliath              |10.00|1.2,1.3,2,3,4,5,6,7|0.2|eq_div|wprecd|           494|   4_940.00|    359_593.07|    354_653.07|
			|Block                |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|eq_div|         1_004|  10_040.00|199_754_893.30|199_744_853.30|
			|Block                |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|wprecd|         1_004|  10_040.00|199_754_893.30|199_744_853.30|
			|Block                |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|eq_div|         1_004|  10_040.00| 24_303_382.66| 24_293_342.66|
			|Block                |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|wprecd|         1_004|  10_040.00| 24_303_382.66| 24_293_342.66|
			|Patent               |10.00|1.2,1.3,1.4        |0.2|w2wp2p|eq_div|            14|     140.00|        188.85|         48.85|
			|Patent               |10.00|1.2,1.3,1.4        |0.2|w2wp2p|wprecd|            14|     140.00|        188.85|         48.85|
			|Patent               |10.00|1.2,1.3,1.4        |0.2|eq_div|eq_div|            14|     140.00|        187.05|         47.05|
			|Patent               |10.00|1.2,1.3,1.4        |0.2|eq_div|wprecd|            14|     140.00|        187.05|         47.05|
			|Yap                  |10.00|2,3,4,5            |0.2|w2wp2p|eq_div|            30|     300.00|      3_964.38|      3_664.38|
			|Yap                  |10.00|2,3,4,5            |0.2|w2wp2p|wprecd|            30|     300.00|      3_964.38|      3_664.38|
			|Yap                  |10.00|2,3,4,5            |0.2|eq_div|eq_div|            30|     300.00|      2_762.21|      2_462.21|
			|Yap                  |10.00|2,3,4,5            |0.2|eq_div|wprecd|            30|     300.00|      2_762.21|      2_462.21|
			|Lucky15              |10.00|2,3,4,5            |0.2|w2wp2p|eq_div|            30|     300.00|      3_964.38|      3_664.38|
			|Lucky15              |10.00|2,3,4,5            |0.2|w2wp2p|wprecd|            30|     300.00|      3_964.38|      3_664.38|
			|Lucky15              |10.00|2,3,4,5            |0.2|eq_div|eq_div|            30|     300.00|      2_762.21|      2_462.21|
			|Lucky15              |10.00|2,3,4,5            |0.2|eq_div|wprecd|            30|     300.00|      2_762.21|      2_462.21|
			|Lucky31              |10.00|2,3,4,5,6          |0.2|w2wp2p|eq_div|            62|     620.00|     26_333.15|     25_713.15|
			|Lucky31              |10.00|2,3,4,5,6          |0.2|w2wp2p|wprecd|            62|     620.00|     26_333.15|     25_713.15|
			|Lucky31              |10.00|2,3,4,5,6          |0.2|eq_div|eq_div|            62|     620.00|     13_891.04|     13_271.04|
			|Lucky31              |10.00|2,3,4,5,6          |0.2|eq_div|wprecd|            62|     620.00|     13_891.04|     13_271.04|
			|Lucky63              |10.00|2,3,4,5,6,7        |0.2|w2wp2p|eq_div|           126|   1_260.00|    205_270.09|    204_010.09|
			|Lucky63              |10.00|2,3,4,5,6,7        |0.2|w2wp2p|wprecd|           126|   1_260.00|    205_270.09|    204_010.09|
			|Lucky63              |10.00|2,3,4,5,6,7        |0.2|eq_div|eq_div|           126|   1_260.00|     77_881.82|     76_621.82|
			|Lucky63              |10.00|2,3,4,5,6,7        |0.2|eq_div|wprecd|           126|   1_260.00|     77_881.82|     76_621.82|
			|SuperHeinzWithSingles|10.00|2,3,4,5,6,7,8      |0.2|w2wp2p|eq_div|           254|   2_540.00|  1_826_926.29|  1_824_386.29|
			|SuperHeinzWithSingles|10.00|2,3,4,5,6,7,8      |0.2|w2wp2p|wprecd|           254|   2_540.00|  1_826_926.29|  1_824_386.29|
			|SuperHeinzWithSingles|10.00|2,3,4,5,6,7,8      |0.2|eq_div|eq_div|           254|   2_540.00|    482_971.31|    480_431.31|
			|SuperHeinzWithSingles|10.00|2,3,4,5,6,7,8      |0.2|eq_div|wprecd|           254|   2_540.00|    482_971.31|    480_431.31|
			|GoliathWithSingles   |10.00|2,3,4,5,6,7,8,9    |0.2|w2wp2p|eq_div|           510|   5_100.00| 18_189_146.66| 18_184_046.66|
			|GoliathWithSingles   |10.00|2,3,4,5,6,7,8,9    |0.2|w2wp2p|wprecd|           510|   5_100.00| 18_189_146.66| 18_184_046.66|
			|GoliathWithSingles   |10.00|2,3,4,5,6,7,8,9    |0.2|eq_div|eq_div|           510|   5_100.00|  3_284_320.90|  3_279_220.90|
			|GoliathWithSingles   |10.00|2,3,4,5,6,7,8,9    |0.2|eq_div|wprecd|           510|   5_100.00|  3_284_320.90|  3_279_220.90|
			|BlockWithSingles     |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|eq_div|         1_022|  10_220.00|199_755_613.30|199_745_393.30|
			|BlockWithSingles     |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|wprecd|         1_022|  10_220.00|199_755_613.30|199_745_393.30|
			|BlockWithSingles     |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|eq_div|         1_022|  10_220.00| 24_304_102.66| 24_293_882.66|
			|BlockWithSingles     |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|wprecd|         1_022|  10_220.00| 24_304_102.66| 24_293_882.66|
			|SingleStakesAbout    |10.00|2,3                |0.2|w2wp2p|eq_div|             4|      40.00|        112.00|         72.00|
			|SingleStakesAbout    |10.00|2,3                |0.2|w2wp2p|wprecd|             4|      40.00|        112.00|         72.00|
			|SingleStakesAbout    |10.00|2,3                |0.2|eq_div|eq_div|             4|      40.00|        112.00|         72.00|
			|SingleStakesAbout    |10.00|2,3                |0.2|eq_div|wprecd|             4|      40.00|        112.00|         72.00|
			|DoubleStakesAbout    |10.00|2,3                |0.2|w2wp2p|eq_div|             4|      40.00|        138.40|         98.40|
			|DoubleStakesAbout    |10.00|2,3                |0.2|w2wp2p|wprecd|             4|      40.00|        144.80|        104.80|
			|DoubleStakesAbout    |10.00|2,3                |0.2|eq_div|eq_div|             4|      40.00|        138.40|         98.40|
			|DoubleStakesAbout    |10.00|2,3                |0.2|eq_div|wprecd|             4|      40.00|        144.80|        104.80|
			|RoundRobin           |10.00|2,3,4              |0.2|w2wp2p|eq_div|            20|     200.00|        993.28|        793.28|
			|RoundRobin           |10.00|2,3,4              |0.2|w2wp2p|wprecd|            20|     200.00|        993.28|        793.28|
			|RoundRobin           |10.00|2,3,4              |0.2|eq_div|eq_div|            20|     200.00|        888.32|        688.32|
			|RoundRobin           |10.00|2,3,4              |0.2|eq_div|wprecd|            20|     200.00|        888.32|        688.32|
			|Flag                 |10.00|2,3,4,5            |0.2|w2wp2p|eq_div|            46|     460.00|      4_724.38|      4_264.38|
			|Flag                 |10.00|2,3,4,5            |0.2|w2wp2p|wprecd|            46|     460.00|      4_724.38|      4_264.38|
			|Flag                 |10.00|2,3,4,5            |0.2|eq_div|eq_div|            46|     460.00|      3_522.21|      3_062.21|
			|Flag                 |10.00|2,3,4,5            |0.2|eq_div|wprecd|            46|     460.00|      3_522.21|      3_062.21|
			|SuperFlag            |10.00|2,3,4,5,6          |0.2|w2wp2p|eq_div|            92|     920.00|     27_893.15|     26_973.15|
			|SuperFlag            |10.00|2,3,4,5,6          |0.2|w2wp2p|wprecd|            92|     920.00|     27_893.15|     26_973.15|
			|SuperFlag            |10.00|2,3,4,5,6          |0.2|eq_div|eq_div|            92|     920.00|     15_451.04|     14_531.04|
			|SuperFlag            |10.00|2,3,4,5,6          |0.2|eq_div|wprecd|            92|     920.00|     15_451.04|     14_531.04|
			|HeinzFlag            |10.00|2,3,4,5,6,7        |0.2|w2wp2p|eq_div|           174|   1_740.00|    208_018.09|    206_278.09|
			|HeinzFlag            |10.00|2,3,4,5,6,7        |0.2|w2wp2p|wprecd|           174|   1_740.00|    208_018.09|    206_278.09|
			|HeinzFlag            |10.00|2,3,4,5,6,7        |0.2|eq_div|eq_div|           174|   1_740.00|     80_629.82|     78_889.82|
			|HeinzFlag            |10.00|2,3,4,5,6,7        |0.2|eq_div|wprecd|           174|   1_740.00|     80_629.82|     78_889.82|
			|SuperHeinzFlag       |10.00|2,3,4,5,6,7,8      |0.2|w2wp2p|eq_div|           324|   3_240.00|  1_831_322.29|  1_828_082.29|
			|SuperHeinzFlag       |10.00|2,3,4,5,6,7,8      |0.2|w2wp2p|wprecd|           324|   3_240.00|  1_831_322.29|  1_828_082.29|
			|SuperHeinzFlag       |10.00|2,3,4,5,6,7,8      |0.2|eq_div|eq_div|           324|   3_240.00|    487_367.31|    484_127.31|
			|SuperHeinzFlag       |10.00|2,3,4,5,6,7,8      |0.2|eq_div|wprecd|           324|   3_240.00|    487_367.31|    484_127.31|
			|GoliathFlag          |10.00|2,3,4,5,6,7,8,9    |0.2|w2wp2p|eq_div|           606|   6_060.00| 18_195_722.66| 18_189_662.66|
			|GoliathFlag          |10.00|2,3,4,5,6,7,8,9    |0.2|w2wp2p|wprecd|           606|   6_060.00| 18_195_722.66| 18_189_662.66|
			|GoliathFlag          |10.00|2,3,4,5,6,7,8,9    |0.2|eq_div|eq_div|           606|   6_060.00|  3_290_896.90|  3_284_836.90|
			|GoliathFlag          |10.00|2,3,4,5,6,7,8,9    |0.2|eq_div|wprecd|           606|   6_060.00|  3_290_896.90|  3_284_836.90|
			|Rounder              |10.00|2,3,4              |0.2|w2wp2p|eq_div|             6|      60.00|        390.40|        330.40|
			|Rounder              |10.00|2,3,4              |0.2|w2wp2p|wprecd|             6|      60.00|        390.40|        330.40|
			|Rounder              |10.00|2,3,4              |0.2|eq_div|eq_div|             6|      60.00|        355.20|        295.20|
			|Rounder              |10.00|2,3,4              |0.2|eq_div|wprecd|             6|      60.00|        355.20|        295.20|
			|Roundabout           |10.00|2,3,4              |0.2|w2wp2p|eq_div|             6|      60.00|        599.84|        539.84|
			|Roundabout           |10.00|2,3,4              |0.2|w2wp2p|wprecd|             6|      60.00|        638.88|        578.88|
			|Roundabout           |10.00|2,3,4              |0.2|eq_div|eq_div|             6|      60.00|        537.12|        477.12|
			# fbc is wrong on this one ?!!?
			|Roundabout           |10.00|2,3,4              |0.2|eq_div|wprecd|             6|      60.00|        555.04|        495.04| 
			|Alphabet             |10.00|2,3,4,5,6,7        |0.2|w2wp2p|eq_div|            52|     520.00|     63_595.13|     63_075.13|
			|Alphabet             |10.00|2,3,4,5,6,7        |0.2|w2wp2p|wprecd|            52|     520.00|     63_595.13|     63_075.13|
			|Alphabet             |10.00|2,3,4,5,6,7        |0.2|eq_div|eq_div|            52|     520.00|     20_470.55|     19_950.55|
			|Alphabet             |10.00|2,3,4,5,6,7        |0.2|eq_div|wprecd|            52|     520.00|     20_470.55|     19_950.55|
			|UnionJackTreble      |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|eq_div|            16|     160.00|     18_528.00|     18_368.00|
			|UnionJackTreble      |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|wprecd|            16|     160.00|     18_528.00|     18_368.00|
			|UnionJackTreble      |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|eq_div|            16|     160.00|     10_528.00|     10_368.00|
			|UnionJackTreble      |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|wprecd|            16|     160.00|     10_528.00|     10_368.00|
			|UnionJackTrixie      |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|eq_div|            64|     640.00|     28_232.00|     27_592.00|
			|UnionJackTrixie      |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|wprecd|            64|     640.00|     28_232.00|     27_592.00|
			|UnionJackTrixie      |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|eq_div|            64|     640.00|     18_280.00|     17_640.00|
			|UnionJackTrixie      |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|wprecd|            64|     640.00|     18_280.00|     17_640.00|
			|UnionJackPatent      |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|eq_div|           112|   1_120.00|     30_152.00|     29_032.00|
			|UnionJackPatent      |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|wprecd|           112|   1_120.00|     30_152.00|     29_032.00|
			|UnionJackPatent      |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|eq_div|           112|   1_120.00|     20_200.00|     19_080.00|
			|UnionJackPatent      |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|wprecd|           112|   1_120.00|     20_200.00|     19_080.00|
			|UnionJackRoundRobin  |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|eq_div|           160|   1_600.00|     34_952.00|     33_352.00|
			|UnionJackRoundRobin  |10.00|2,3,4,5,6,7,8,9,10 |0.2|w2wp2p|wprecd|           160|   1_600.00|     34_952.00|     33_352.00|
			|UnionJackRoundRobin  |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|eq_div|           160|   1_600.00|     25_000.00|     23_400.00|
			|UnionJackRoundRobin  |10.00|2,3,4,5,6,7,8,9,10 |0.2|eq_div|wprecd|           160|   1_600.00|     25_000.00|     23_400.00|
			|Single               |10.00|2,3,4,5            |0.2|w2wp2p|eq_div|             8|      80.00|        200.00|        120.00|
            |Trixie               |10.00|1.1,1.2,1.3,1.4    |0.2|eq_div|eq_div|            32|     320.00|        438.30|        118.30|
            |RoundRobin           |10.00|1.1,1.2,1.3,0.4    |0.2|w2wp2p|eq_div|            80|     800.00|        783.81|        -16.19|
            |RoundRobin           |10.00|1.1,1.2,1.3,0.4    |0.2|w2wp2p|wprecd|            80|     800.00|        787.27|        -12.73|
            |RoundRobin           |10.00|1.1,1.2,1.3,0.4    |0.2|eq_div|eq_div|            80|     800.00|        787.36|        -12.64|
            |RoundRobin           |10.00|1.1,1.2,1.3,0.4    |0.2|eq_div|wprecd|            80|     800.00|        790.81|         -9.19|
