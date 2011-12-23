Feature: Move Robot
  Conveyor belts move robots one or two fields. 
  Conflicts when moving are resolved by not moving any robot involved in the moving at all.

  Scenario: A robot on a conveyor belt going east
    Given there is a board:
        | Ce | Ce | Ce |
    And there is a robot at 0, 0 facing east
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
        
  Scenario: A robot on a conveyor belt going west
    Given there is a board:
        | Cw | Cw | Cw |
    And there is a robot at 2, 0 facing west
    When a turn is played
    Then the 1st robot is at 1, 0 facing west
            
  Scenario: A robot on a conveyor belt going south
    Given there is a board:
        | Cs |
        | Cs |
        | Cs |
    And there is a robot at 0, 0 facing south
    When a turn is played
    Then the 1st robot is at 0, 1 facing south    
            
  Scenario: A robot on a conveyor belt going north
    Given there is a board:
        | Cn |
        | Cn |
        | Cn |
    And there is a robot at 0, 2 facing north
    When a turn is played
    Then the 1st robot is at 0, 1 facing north

  Scenario: A robot on an express conveyor belt going east
    Given there is a board:
        | Ce* | Ce* | Ce* |
    And there is a robot at 0, 0 facing east
    When a turn is played
    Then the 1st robot is at 2, 0 facing east
        
  Scenario: A robot on an express conveyor belt going west
    Given there is a board:
        | Cw* | Cw* | Cw* |
    And there is a robot at 2, 0 facing west
    When a turn is played
    Then the 1st robot is at 0, 0 facing west
            
  Scenario: A robot on an express conveyor belt going south
    Given there is a board:
        | Cs* |
        | Cs* |
        | Cs* |
    And there is a robot at 0, 0 facing south
    When a turn is played
    Then the 1st robot is at 0, 2 facing south    
            
  Scenario: A robot on an express conveyor belt going north
    Given there is a board:
        | Cn* |
        | Cn* |
        | Cn* |
    And there is a robot at 0, 2 facing north
    When a turn is played
    Then the 1st robot is at 0, 0 facing north
            
  Scenario: A robot on an express conveyor belt going round
    Given there is a board:
        | Csl | Cw | Cwl |
        | Cs  |    | Cn  |
        | Cel | Ce | Cnl |
    And there is a robot at 0, 0 facing south
    When a turn is played
    Then the 1st robot is at 0, 1 facing south
    When a turn is played
    Then the 1st robot is at 0, 2 facing east
    When a turn is played
    Then the 1st robot is at 1, 2 facing east
    When a turn is played
    Then the 1st robot is at 2, 2 facing north
    When a turn is played
    Then the 1st robot is at 2, 1 facing north
    When a turn is played
    Then the 1st robot is at 2, 0 facing west
    When a turn is played
    Then the 1st robot is at 1, 0 facing west
    When a turn is played
    And there is a robot at 0, 0 facing south
    