Feature: Conveyor board element
  Conveyor belts move robots in their given direction.
  They can move twice per round, when they are express conveyors.
  Robots can be rotated when being conveyed onto another conveyor.
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
            
  Scenario: A robot on a conveyor belt going round counter clock wise
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
            
  Scenario: A robot on a conveyor belt going round clockwise
    Given there is a board:
      | Cer | Ce | Csr |
      | Cn  |    | Cs  |
      | Cnr | Cw | Cwr |
    And there is a robot at 0, 0 facing east
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    When a turn is played
    Then the 1st robot is at 2, 0 facing south
    When a turn is played
    Then the 1st robot is at 2, 1 facing south
    When a turn is played
    Then the 1st robot is at 2, 2 facing west
    When a turn is played
    Then the 1st robot is at 1, 2 facing west
    When a turn is played
    Then the 1st robot is at 0, 2 facing north
    When a turn is played
    Then the 1st robot is at 0, 1 facing north
    When a turn is played
    And there is a robot at 0, 0 facing east
              
  Scenario: Two robots on a conveyor belt blocking each others turn
    Given there is a board:
      | Ce |  | Cw |
    And there is a robot at 0, 0 facing east
    And there is a robot at 2, 0 facing west
    When a turn is played  
    Then the 1st robot is at 0, 0 facing east
    Then the 2nd robot is at 2, 0 facing west
              
  Scenario: Three robots on a conveyor belt blocking each others turn
    Given there is a board:
      | Ce | Ce | Csrl | Cw |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing east
    And there is a robot at 3, 0 facing west
    When a turn is played  
    Then the 1st robot is at 0, 0 facing east
    Then the 2nd robot is at 1, 0 facing east    
    Then the 3rd robot is at 3, 0 facing west
  
  Scenario: A conveyor belt will not move robots on top of other robots
    Given there is a board:
      | Ce |  |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing west
    When a turn is played
    Then the 1st robot is at 0, 0 facing east
    Then the 2nd robot is at 1, 0 facing west
    
  Scenario: Conveyance on express and normal tiles
    Given there is a board:
      | Ce* | Ce |  |
    And there is a robot at 0, 0 facing east
    When a turn is played  
    Then the 1st robot is at 2, 0 facing east
        
  Scenario: A group of robots on a conveyor belt
    Given there is a board:
      | Ce | Ce | Ce |  |
    And there is a robot at 0, 0 facing west
    And there is a robot at 1, 0 facing west
    And there is a robot at 2, 0 facing west
    When a turn is played
    Then the 1st robot is at 1, 0 facing west
    Then the 2nd robot is at 2, 0 facing west
    Then the 3rd robot is at 3, 0 facing west
    When a turn is played
    Then the 1st robot is at 1, 0 facing west
    Then the 2nd robot is at 2, 0 facing west
    Then the 3rd robot is at 3, 0 facing west
    
    
    
    