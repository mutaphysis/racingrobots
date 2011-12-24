Feature: Movement cards
  There are different cards, used to move or turn robots.
  uturn - turn the robot 180° 
  rotateleft, rotateright - rotate 90° 
  backup - move one field back
  moveone, movetwo, movethree - move one to three fields ahead

  Scenario: A robot using uturn
    Given there is a board:
        |  |
    And there is a robot at 0, 0 facing north
	And the 1st robots program is:
		| uturn:10 | uturn:20 | uturn:30 | uturn:40 | uturn:50 |
    When a turn is played
    Then the 1st robot is at 0, 0 facing south
    When a turn is played
    Then the 1st robot is at 0, 0 facing north

  Scenario: A robot using rotateleft
    Given there is a board:
        |  |
    And there is a robot at 0, 0 facing north
	And the 1st robots program is:
		| rotateleft:10 | rotateleft:20 | rotateleft:30 | rotateleft:40 | rotateleft:50 |
    When a turn is played
    Then the 1st robot is at 0, 0 facing west
    When a turn is played
    Then the 1st robot is at 0, 0 facing south
    When a turn is played
    Then the 1st robot is at 0, 0 facing east
    When a turn is played
    Then the 1st robot is at 0, 0 facing north

  Scenario: A robot using rotateright
    Given there is a board:
        |  |
    And there is a robot at 0, 0 facing north
	And the 1st robots program is:
		| rotateright:10 | rotateright:20 | rotateright:30 | rotateright:40 | rotateright:50 |
    When a turn is played
    Then the 1st robot is at 0, 0 facing east
    When a turn is played
    Then the 1st robot is at 0, 0 facing south
    When a turn is played
    Then the 1st robot is at 0, 0 facing west
    When a turn is played
    Then the 1st robot is at 0, 0 facing north
