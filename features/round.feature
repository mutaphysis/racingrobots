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
    Then the 1st robot has 9 program cards 
	Then the 2nd robot has 8 program cards 
	Then the 3rd robot has 5 program cards 