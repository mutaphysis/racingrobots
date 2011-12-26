Feature: Lasers
  Mounted lasers and robots fire laser beams in their view direction, lasers are blocked by walls and robots

  Scenario: Laser firing east
    Given there is a board:
      | Le |  |
    And there is a robot at 1, 0 facing west
    When a turn is played
    Then the 1st robot has taken 1 damage
    When a turn is played
    Then the 1st robot has taken 2 damage
  
  Scenario: Laser firing east
    Given there is a board:
      |  | Lw |
    And there is a robot at 0, 0 facing west
    When a turn is played
    Then the 1st robot has taken 1 damage
    When a turn is played
    Then the 1st robot has taken 2 damage
      
  Scenario: Laser firing south
    Given there is a board:
      | Ls |
      |    |
    And there is a robot at 0, 1 facing west
    When a turn is played
    Then the 1st robot has taken 1 damage
    When a turn is played
    Then the 1st robot has taken 2 damage
      
  Scenario: Laser firing north
    Given there is a board:
      |    |
      | Ln |
    And there is a robot at 0, 0 facing west
    When a turn is played
    Then the 1st robot has taken 1 damage
    When a turn is played
    Then the 1st robot has taken 2 damage
      
  Scenario: Laser also damage robots standing on their field
    Given there is a board:
      | Le |
    And there is a robot at 0, 0 facing west
    When a turn is played
    Then the 1st robot has taken 1 damage
    When a turn is played
    Then the 1st robot has taken 2 damage
      
  Scenario: Lasers are blocked by robots
    Given there is a board:
      | Le |  |  |
    And there is a robot at 0, 0 facing north
    And there is a robot at 1, 0 facing north
    When a turn is played
    Then the 1st robot has taken 1 damage
    Then the 2nd robot has taken 0 damage
    When a turn is played
    Then the 1st robot has taken 2 damage
    Then the 2nd robot has taken 0 damage
      
  Scenario: More lasers do more damage
    Given there is a board:
      | Le |  | Lw |
    And there is a robot at 1, 0 facing north
    When a turn is played
    Then the 1st robot has taken 2 damage
    When a turn is played
    Then the 1st robot has taken 4 damage
      
  Scenario: Nine damage will kill a robot
    # But in one phase no damage overflow will carry through other robots behind it
    Given there is a board:
      | Le | Le |    |
    And there is a robot at 1, 0 facing north
    And there is a robot at 2, 0 facing north
    When a turn is played
    Then the 1st robot has taken 2 damage
    When a turn is played
    Then the 1st robot has taken 4 damage
    When a turn is played
    Then the 1st robot has taken 6 damage
    When a turn is played
    Then the 1st robot has taken 8 damage
    When a turn is played
    Then the 1st robot is destroyed
    Then the 2nd robot has taken 0 damage
      
  Scenario: Robots have head mounted lasers
    Given there is a board:
      |  |  |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing north
    When a turn is played
    Then the 2nd robot has taken 1 damage
    When a turn is played
    Then the 2nd robot has taken 2 damage


    