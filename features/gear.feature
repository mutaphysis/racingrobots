Feature: Gear board element
  Gears turn robots clockwise or counterclockwise.
  They don't move robots.

  Scenario: A robot on a clockwise gear 
    Given there is a board:
        | Gr |
    And there is a robot at 0, 0 facing east
    When a turn is played
    Then the 1st robot is at 0, 0 facing south
    When a turn is played
    Then the 1st robot is at 0, 0 facing west
    When a turn is played
    Then the 1st robot is at 0, 0 facing north
    When a turn is played
    Then the 1st robot is at 0, 0 facing east

  Scenario: A robot on a counter clockwise gear 
    Given there is a board:
        | Gl |
    And there is a robot at 0, 0 facing east
    When a turn is played
    Then the 1st robot is at 0, 0 facing north
    When a turn is played
    Then the 1st robot is at 0, 0 facing west
    When a turn is played
    Then the 1st robot is at 0, 0 facing south
    When a turn is played
    Then the 1st robot is at 0, 0 facing east
