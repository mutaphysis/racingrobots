Feature: Game
  A game

  Scenario: Game can be run
    Given there is a board:
      | S1 |    |    |
      |    |    |    |
      |    |    | S2 |
    And there are 2 robots

    When the game is started
    And the game is continued
    Then there should be 0 rounds played
    And there should be 0 turns played
    And the game should await the following input
      | choose_program_cards | choose_initial_direction |

    When the 1st robot choses to start facing south
    And the 2nd robot choses to start facing north
    Then the game should await the following input
      | choose_program_cards |

    And the 1st robot chooses an empty program
    And the 2nd robot chooses an empty program
    Then the game should not await input

    When the game is continued
    Then there should be 1 round played
    And there should be 0 turns played
    And the game should await the following input
      | choose_program_cards |

    When the 1st robot chooses an empty program
    And the 2nd robot chooses an empty program
    Then the game should not await input

    When the game is continued
    Then there should be 2 rounds played
    And there should be 0 turns played
    And the game should await the following input
      | choose_program_cards |

    When the 1st robot chooses an empty program
    And the 2nd robot chooses an empty program
    Then the game should not await input