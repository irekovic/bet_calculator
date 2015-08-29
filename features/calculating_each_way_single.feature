Feature: Calculating Singles
  Calculator should know how to handle singles, with one and more than one leg.

    Scenario: Calculates single with exact number of legs
      Given the "Single" bet type with stake "10" on legs:
        |price|place|wwp|wvp|
        |1.2  |0.2  |1.0|  0|
      When I calculate the bet
      Then number_of_bets should be "1"
       And total_stake should be "10"
       And total_return should be "12.00"
       And unit_stake should be "10.00"
       And total_profit should be "2.00"

    Scenario: Calculates single with more than minimum number of legs
      Given the "Single" bet type with stake "10" on legs:
        |price|place|wwp|wvp|
        |2.00 |0.2  |1.0|0.0|
        |3.00 |0.2  |0.0|0.0|
        |4.00 |0.2  |0.0|0.0|
        |5.00 |0.2  |0.0|1.0|
      When I calculate the bet
      Then number_of_bets should be "4"
       And total_stake should be "40"
       And total_return should be "30.00"
       And unit_stake should be "10.00"
       And total_profit should be "-10.00"

    Scenario: Calculate each-way single with one leg
      Given the "Single" bet type with stake "10" on leg:
        |price|place|wwv|wvp|
