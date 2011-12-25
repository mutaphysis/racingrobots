Feature: Pusher board element
  Pusher push robots. This can lead to other robots being pushed as well

  Scenario: A pusher pushing east
    Given there is a board:
      | Pe |  |
    And there is a robot at 0, 0 facing east
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    When a turn is played
    Then the 1st robot is at 1, 0 facing east

  Scenario: A pusher pushing multiple robots
    Given there is a board:
      | Pe |  |  |
    And there is a robot at 0, 0 facing east
    And there is a robot at 1, 0 facing east
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    Then the 2nd robot is at 2, 0 facing east
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    Then the 2nd robot is at 2, 0 facing east

