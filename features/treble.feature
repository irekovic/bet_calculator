Feature: Treble bets
  
  Scenario: Each Way Combinatorial Treble
    Given the "Treble" bet type with stake "10" on legs:
      | price | place | w_w | w_v | p_w | p_v |
      | 2.00  | 0.2   | 1   | 0   | 1   | 0   |
      | 3.00  | 0.2   | 0   | 0   | 1   | 0   |
      | 4.00  | 0.2   | 0   | 0   | 0   | 0   |
      | 5.00  | 0.2   | 0   | 1   | 0   | 1   |
      | 6.00  | 0.2   | 1   | 0   | 1   | 0   |
      | 7.00  | 0.2   | 1   | 0   | 1   | 0   |
    When I calculate each-way bet with accumulators settled as "w2w_p2p" and atc settled as "eq_div"
    Then number_of_bets should be "40"
     And total_stake should be "400"
     And total_return should be "1_874.96"
     And total_profit should be "1_474.96"
