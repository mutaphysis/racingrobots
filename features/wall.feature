Feature: Walls
  Walls block movement of robots and lasers

  Scenario: A robot cannot move through a wall
    Given there is a board:
      |  | We |  |
    And there is a robot at 0, 0 facing east
    And the 1st robots program is:
  	  | movetwo:10 | movetwo:20 |
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    When a turn is played
    Then the 1st robot is at 1, 0 facing east

  Scenario: A wall on the west
    Given there is a board:
      |  | Ww |  |
    And there is a robot at 0, 0 facing east
    And the 1st robots program is:
  	  | moveone:10 |
    When a turn is played
    Then the 1st robot is at 0, 0 facing east

  Scenario: A wall on the south
    Given there is a board:
      |    |
      | Ws |  
      |    |
    And there is a robot at 0, 0 facing south
    And the 1st robots program is:
  	  |  movetwo:10 | movetwo:20 |
    When a turn is played
    Then the 1st robot is at 0, 1 facing south
    When a turn is played
    Then the 1st robot is at 0, 1 facing south

  Scenario: A wall on the south
    Given there is a board:
      |    |
      | Wn |
    And there is a robot at 0, 0 facing south
    And the 1st robots program is:
  	  |  moveone:10 |
    When a turn is played
    Then the 1st robot is at 0, 0 facing south  


  Scenario: A robot cannot push another through a wall
    Given there is a board:
      |  |  | We |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing east
    And the 1st robots program is:
  	  | moveone:10 | moveone:10 |  
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    Then the 2nd robot is at 2, 0 facing east
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    Then the 2nd robot is at 2, 0 facing east
      

  Scenario: A robot cannot push another through a wall even fast
    Given there is a board:
      |  |  | We |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing east
    And the 1st robots program is:
  	  | movetwo:10 | movetwo:20 | movetwo:30 | movetwo:40 | movetwo:50 |
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    Then the 2nd robot is at 2, 0 facing east
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    Then the 2nd robot is at 2, 0 facing east
