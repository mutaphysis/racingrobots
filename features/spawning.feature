Feature: Spawning
  At the beginning of a game robots are randomly assigned to starting points
  They are placed on those starting points, the players choose their facing
  Their first save point is their intial starting point
  When a robot is destroyed, it is respawned next turn

  Scenario: Robots are assigned to starting points
    Given there is a board:
      | S1 |  | S2 |  | S3 |  | S4 |
    And there are 4 robots

    When the game is started
    And the 1st robot choses to start facing north
    And the 2nd robot choses to start facing north
    And the 3rd robot choses to start facing north
    And the 4th robot choses to start facing north

    Then there should be a robot at 0, 0
    Then the previous robot should be saved at 0, 0

    Then there should be no robot at 1, 0

    Then there should be a robot at 2, 0
    Then the previous robot should be saved at 2, 0

    Then there should be no robot at 3, 0

    Then there should be a robot at 4, 0
    Then the previous robot should be saved at 4, 0

    Then there should be no robot at 5, 0

    Then there should be a robot at 6, 0
    Then the previous robot should be saved at 6, 0

  Scenario: Robots are respawned after death in the next round, bearing two damage
    Given there is a board:
      |  |  |
    And there is a robot at 0, 0 facing south
    And the 1st robot was already saved at 1, 0
    And the 1st robot already has taken 10 damage

    Then the 1st robot should not be destroyed

    When a turn is played
    Then the 1st robot should be destroyed

    When a round is ended
    And a round is started
    Then the 1st robot should not be destroyed
    And the 1st robot should have taken 2 damage
    And the 1st robot choses to respawn facing north
    And the 1st robot should be at 1, 0 facing north
    And there should be a robot at 1, 0

  Scenario:  Robots that are spawned at the beginning of the game need to chose their direction before the game continues
    Given there is a board:
      | S1 |  |
    And there is 1 robot

    When the game is started
    Then the round cannot be continued

    When the 1st robot choses to start facing north
    Then the round can be continued



  Scenario: Robots that are respawned need to chose their direction/position before the game continues
    Given there is a board:
      |  |  |
    And there is a destroyed robot saved at 1, 0

    When a round is started
    And the previous robot chooses a random program
    Then the round cannot be continued

    When the previous robot choses to respawn facing north
    Then the round can be continued

  

    