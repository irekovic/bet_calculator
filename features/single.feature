Feature: Calculating Singles
  Calculator should know how to handle singles, with one and more than one leg.
    Scenario: Calculates single with exact number of legs
      Given the "Single" bet type with stake "10" on legs:
        |price|wwp|wvp|
        |  1.2|  1|  0|
      When I calculate the bet
      Then number_of_bets should be "1"
       And total_stake should be "10"
       And total_return should be "12.00"
       And unit_stake should be "10.00"
       And total_profit should be "2.00"

    Scenario: Calculates single with more than minimum number of legs
      Given the "Single" bet type with stake "10" on legs:
        |price|w_w|w_v|
        | 2.00|  1|  0|
        | 3.00|  0|  0|
        | 4.00|  0|  0|
        | 5.00|  0|  1|
      When I calculate the bet
      Then number_of_bets should be "4"
       And total_stake should be "40"
       And total_return should be "30.00"
       And unit_stake should be "10.00"
       And total_profit should be "-10.00"

    Scenario: Calculate each-way single with one leg
      Given the "Single" bet type with stake "10" on leg:
        |price|place|w_w|w_v|p_w|p_v|
        | 2.00|  0.2|  1|  0|  1|  0|
        | 3.00|  0.2|  0|  0|  1|  0|
        | 4.00|  0.2|  0|  0|  0|  0|
        | 5.00|  0.2|  0|  1|  0|  1|
      When I calculate each-way bet with accumulators settled as "w2w_p2p" and atc settled as "eq_div"
      Then number_of_bets should be "8"
       And total_stake should be "80"
       And total_return should be "66.00"
       And unit_stake should be "10.00"
       And total_profit should be "-14.00"

