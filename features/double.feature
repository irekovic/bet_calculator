Feature: Calculating Doubles
  Calculator should know how to handle double & doubles, with two and more than one leg.

    Scenario: Calculates double with exact number of legs
      Given the "Double" bet type with stake "10" on legs:
        |price|wwp|wvp|
        |  1.2|  1|  0|
        |  1.3|  1|  0|
      When I calculate the bet
      Then number_of_bets should be "1"
       And total_stake should be "10"
       And total_return should be "15.60"
       And unit_stake should be "10.00"
       And total_profit should be "5.60"

    Scenario: Calculates double with more than minimum number of legs
      Given the "Double" bet type with stake "10" on legs:
        |price|w_w|w_v|
        | 2.00|  1|  0|
        | 3.00|  0|  0|
        | 4.00|  0|  0|
        | 5.00|  0|  1|
      When I calculate the bet
      Then number_of_bets should be "6"
       And total_stake should be "60"
       And total_return should be "20.00"
       And unit_stake should be "10.00"
       And total_profit should be "-40.00"

    Scenario: Calculate each-way double with one leg
      Given the "Double" bet type with stake "10" on leg:
        |price|place|w_w|w_v|p_w|p_v|
        | 2.00|  0.2|  1|  0|  1|  0|
        | 3.00|  0.2|  0|  0|  1|  0|
        | 4.00|  0.2|  0|  0|  0|  0|
        | 5.00|  0.2|  0|  1|  0|  1|
      When I calculate each-way bet with accumulators settled as "w2w_p2p" and atc settled as "eq_div"
      Then number_of_bets should be "12"
       And total_stake should be "120"
       And total_return should be "62.80"
       And unit_stake should be "10.00"
       And total_profit should be "-57.20"

