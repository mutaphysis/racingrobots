Feature: Walls
  Walls block movement of robots and lasers

  Scenario: A robot cannot move through a wall
    Given there is a board:
      |  | We |  |
    And there is a robot at 0, 0 facing east
    And the 1st robots program is:
      | movetwo:10 | movetwo:20 |
    When a turn is played
    Then the 1st robot should be at 1, 0 facing east
    When a turn is played
    Then the 1st robot should be at 1, 0 facing east

  Scenario: A wall on the west
    Given there is a board:
      |  | Ww |  |
    And there is a robot at 0, 0 facing east
    And the 1st robots program is:
      | moveone:10 |
    When a turn is played
    Then the 1st robot should be at 0, 0 facing east

  Scenario: A wall on the south
    Given there is a board:
      |    |
      | Ws |
      |    |
    And there is a robot at 0, 0 facing south
    And the 1st robots program is:
      | movetwo:10 | movetwo:20 |
    When a turn is played
    Then the 1st robot should be at 0, 1 facing south
    When a turn is played
    Then the 1st robot should be at 0, 1 facing south

  Scenario: A wall on the south
    Given there is a board:
      |    |
      | Wn |
    And there is a robot at 0, 0 facing south
    And the 1st robots program is:
      | moveone:10 |
    When a turn is played
    Then the 1st robot should be at 0, 0 facing south

  Scenario: A robot cannot push another through a wall
    Given there is a board:
      |  |  | We |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing east
    And the 1st robots program is:
      | moveone:10 | moveone:10 |
    When a turn is played
    Then the 1st robot should be at 1, 0 facing east
    Then the 2nd robot should be at 2, 0 facing east
    When a turn is played
    Then the 1st robot should be at 1, 0 facing east
    Then the 2nd robot should be at 2, 0 facing east

  Scenario: A robot cannot push another through a wall even fast
    Given there is a board:
      |  |  | We |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing east
    And the 1st robots program is:
      | movetwo:10 | movetwo:20 |
    When a turn is played
    Then the 1st robot should be at 1, 0 facing east
    Then the 2nd robot should be at 2, 0 facing east
    When a turn is played
    Then the 1st robot should be at 1, 0 facing east
    Then the 2nd robot should be at 2, 0 facing east

  Scenario: A pusher cannot push a robot through a wall
    Given there is a board:
      | Pe | Ww |
    And there is a robot at 0, 0 facing east
    When a turn is played
    Then the 1st robot should be at 0, 0 facing east

  Scenario: A pusher cannot push robots through walls
    Given there is a board:
      | Ww | Pw |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing east
    When a turn is played
    Then the 1st robot should be at 0, 0 facing east
    Then the 2nd robot should be at 1, 0 facing east

  Scenario: A conveyor should not convey through walls
    Given there is a board:
      | Ce We | Ce |
    And there is a robot at 0, 0 facing east
    When a turn is played
    Then the 1st robot should be at 0, 0 facing east

  Scenario: A laser should not fire through walls
    Given there is a board:
      | Le | We Ww | Lw |
    And there is a robot at 1, 0 facing east
    When a turn is played
    Then the 1st robot should have taken 0 damage

  Scenario: A robot should not fire through walls
    Given there is a board:
      |  | We Ww |  |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing east
    And there is a robot at 2, 0 facing west
    When a turn is played
    Then the 1st robot should have taken 0 damage
    Then the 2nd robot should have taken 0 damage
    Then the 3rd robot should have taken 0 damage    

