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
	
  Scenario: A robot using backup is moved back one space
    Given there is a board:
      |  |  |  |
    And there is a robot at 0, 0 facing west
	  And the 1st robots program is:
		  | backup:10 | backup:20 | backup:30 | backup:40 | backup:50 |
    When a turn is played
    Then the 1st robot is at 1, 0 facing west
    When a turn is played
    Then the 1st robot is at 2, 0 facing west

  Scenario: A robot using moveone is moved one space
    Given there is a board:
      |  |  |  |
    And there is a robot at 0, 0 facing east
	  And the 1st robots program is:
		  | moveone:10 | moveone:20 | moveone:30 | moveone:40 | moveone:50 |
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
    When a turn is played
    Then the 1st robot is at 2, 0 facing east

  Scenario: A robot using movetwo is moved two spaces
    Given there is a board:
      |  |  |  |  |  |
    And there is a robot at 0, 0 facing east
	  And the 1st robots program is:
		  | movetwo:10 | movetwo:20 | movetwo:30 | movetwo:40 | movetwo:50 |
    When a turn is played
    Then the 1st robot is at 2, 0 facing east
    When a turn is played
    Then the 1st robot is at 4, 0 facing east

  Scenario: A robot using movethree is moved three spaces
    Given there is a board:
        |  |  |  |  |  |  |  |
    And there is a robot at 0, 0 facing east
	  And the 1st robots program is:
		  | movethree:10 | movethree:20 | movethree:30 | movethree:40 | movethree:50 |
    When a turn is played
    Then the 1st robot is at 3, 0 facing east
    When a turn is played
    Then the 1st robot is at 6, 0 facing east

  Scenario: A robot using move is pushing another robot
    Given there is a board:
      |  |  |  |  |  |
    And there is a robot at 0, 0 facing east
	  And there is a robot at 1, 0 facing east
	  And the 1st robots program is:
		  | moveone:10 | moveone:20 | moveone:30 | moveone:40 | moveone:50 |
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
	  Then the 2nd robot is at 2, 0 facing east
    When a turn is played
    Then the 1st robot is at 2, 0 facing east
	  Then the 2nd robot is at 3, 0 facing east

  Scenario: A robot using move is pushing a group of robots
    Given there is a board:
      |  |  |  |  |  |
    And there is a robot at 0, 0 facing east
	  And there is a robot at 1, 0 facing east
    And there is a robot at 2, 0 facing east
	  And the 1st robots program is:
		  | moveone:10 | moveone:20 | moveone:30 | moveone:40 | moveone:50 |
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
	  Then the 2nd robot is at 2, 0 facing east
	  Then the 3rd robot is at 3, 0 facing east
    When a turn is played
    Then the 1st robot is at 2, 0 facing east
	  Then the 2nd robot is at 3, 0 facing east
	  Then the 3rd robot is at 4, 0 facing east

  Scenario: Robot actions are resolved by following program priorities
    Given there is a board:
        |  |  |  |
		    |  |  |  | 
    And there is a robot at 0, 0 facing east
	  And there is a robot at 1, 1 facing north
	  And the 1st robots program is:
		  | moveone:10 |
	  And the 2nd robots program is:
		  | moveone:100 |
    When a turn is played
    Then the 1st robot is at 1, 0 facing east
	  Then the 2nd robot is at 2, 0 facing north
