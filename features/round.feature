Feature: Round
  A round consists out of 5 turns

  Scenario: At the beginning of the round cards are dealt
    Given there is a board:
      |  |  |  |
    And there is a robot at 0, 0 facing south
  	And there is a robot at 1, 0 facing south
  	And the 2nd robot already has taken 1 damage
  	And there is a robot at 2, 0 facing south
  	And the 3rd robot already has taken 4 damage
  	When a round is started
    Then the 1st robot should have 9 program cards 
  	Then the 2nd robot should have 8 program cards 
  	Then the 3rd robot should have 5 program cards 
	
 Scenario: A round can only be continued when all robots have choosen their program
    Given there is a board:
      |  |  |  |
    And there is a robot at 0, 0 facing south
  	And there is a robot at 1, 0 facing south
  	And there is a robot at 2, 0 facing south
  	When a round is started
  	And the 1st robot chooses the program
  	  | 0 | 1 | 2 | 3 | 4 |
  	Then the round cannot be continued
  	When the 2nd robot chooses the program
  	  | 0 | 1 | 2 | 3 | 4 |
  	Then the round cannot be continued
  	When the 3rd robot chooses the program
  	  | 0 | 1 | 2 | 3 | 4 |
  	Then the round can be continued
	