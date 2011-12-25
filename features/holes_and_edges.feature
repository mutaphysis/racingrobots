Feature: Holes and edges
  Falling into holes or driving over edges will kill a robot.
  This will happen when a robot is pushed or conveyed into one as well.

  Scenario: A robot driving off the edge east
    Given there is a board:
      |  |
    And there is a robot at 0, 0 facing east
	  And the 1st robots program is:
		  | moveone:10 |
    When a turn is played
    Then the 1st robot is destroyed
    
    Scenario: A robot driving off the edge west
      Given there is a board:
        |  |
      And there is a robot at 0, 0 facing west
  	  And the 1st robots program is:
  		  | moveone:10 |
      When a turn is played
      Then the 1st robot is destroyed
    
    Scenario: A robot driving off the edge south
      Given there is a board:
        |  |
      And there is a robot at 0, 0 facing south
  	  And the 1st robots program is:
  		  | moveone:10 |
      When a turn is played
      Then the 1st robot is destroyed
    
    Scenario: A robot driving off the edge north
      Given there is a board:
        |  |
      And there is a robot at 0, 0 facing north
  	  And the 1st robots program is:
  		  | moveone:10 |
      When a turn is played
      Then the 1st robot is destroyed
    
    Scenario: A destroyed robot should not act further
      Given there is a board:
        |  |  |  |
      And there is a robot at 0, 0 facing east
      And there is a robot at 1, 0 facing north
      And there is a robot at 2, 0 facing west
  	  And the 2nd robots program is:
  		  | backup:100 | moveone:20 |
  	  And the 3rd robots program is:
  		  | moveone:10 | uturn:10 |
      When a turn is played
      Then the 1st robot is at 0, 0 facing east
      Then the 2nd robot is destroyed
      Then the 3rd robot is at 1, 0 facing west
      
