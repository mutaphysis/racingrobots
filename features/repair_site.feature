Feature: Repair site element
  Robots save at repair sites at the end of every turn
  On the fith turn, at the end of a round, they also heal one point of damage

  Scenario: At the end of a turn 
    Given there is a board:
      | R |
    And there is a robot at 0, 0 facing east
    Then the 1st robot should not be saved
    When a turn is played
    Then the 1st robot should be saved at 0, 0
    
