Feature: Round
  At the beginning of a game robots are randomly assigned to starting points
  They are placed on those starting points, the players choose their facing
  Their first save point is their intial starting point

  Scenario: Robots are assigned to starting points
    Given there is a board:
      | S1 |  | S2 |  | S3 |  | S4 |
    And there are 4 robots

    When the game is started
    And the 1st robot choses to face north
    And the 2nd robot choses to face north
    And the 3rd robot choses to face north
    And the 4th robot choses to face north

    Then there should be a Robot at 0, 0
    Then there should be no Robot at 1, 0
    Then there should be a Robot at 2, 0
    Then there should be no Robot at 3, 0
    Then there should be a Robot at 4, 0
    Then there should be no Robot at 5, 0
    Then there should be a Robot at 6, 0
