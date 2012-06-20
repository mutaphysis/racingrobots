Feature: Robots using their program cards
  A robot can only build a program with the cards it received
  A robot can only build a program with enough cards to fill up all the remaining slots
  Each point of damage exceeding four locks one program cards
  Locked program cards are not dealt in the next turn
  The robot is not allowed to change locked program cards

  Scenario: A robot can only build a program with the cards it received
    Given there is a board:
      |  |  |  |  |  |
    And there is a robot at 0, 0 facing east
    And the previous robot has received the following cards
      | rotateleft:70 | rotateleft:80 | rotateleft:90 | rotateleft:100 | rotateleft:110 | rotateleft:120 | rotateleft:130 | rotateleft:140 | rotateleft:150 |

    Then the previous robot should fail choosing the following program
      | movethree:810 | rotateleft:70 | rotateleft:80 | rotateleft:90 | rotateleft:100 |
    And the previous robot should fail choosing the following program
      | rotateleft:70 | rotateleft:70 | rotateleft:70 | rotateleft:70 | rotateleft:70 |
    And the previous robot should fail choosing the following program
      | rotateleft:70 | rotateleft:80 | rotateleft:90 | rotateleft:100 |
    And the previous robot should fail choosing the following program
      | rotateleft:70 | rotateleft:80 | rotateleft:90 | rotateleft:100 | rotateleft:110 | rotateleft:120 |

    When the previous robot already has taken 6 damage
    Then the previous robot should fail choosing the following program
      | rotateleft:70 | rotateleft:80 | rotateleft:90 | rotateleft:100 | rotateleft:110 | rotateleft:120 |

    Then the previous robot should not fail choosing the following program
      | rotateleft:70 | rotateleft:80 | rotateleft:90 |
    Then the game should not await the following input
      | choose_program_cards |
