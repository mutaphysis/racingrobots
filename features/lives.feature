Feature: Lives
  Each robot gets three life tokens
  Each time a robot is destroyed a life token is taken away
  If a robot is destroyed with just one life tokens, it is removed from the game and does not respawn anymore

  Scenario: A fresh robot has three life tokens
    Given there is a board:
      | |
    And there is a robot at 0, 0 facing west
    Then the previous robot should have 3 lives

  Scenario: A destroyed robot loses one life
    Given there is a board:
      | |
    And there is a robot at 0, 0 facing west
    And the previous robot already has taken 10 damage

    When a turn is played
    Then the previous robot should be destroyed
    Then the previous robot should have 2 lives

  Scenario: A robot with no life tokens is not respawned
    Given there is a board:
      | |
    And there is a robot at 0, 0 facing west
    And the previous robot was already saved at 0, 0
    And the previous robot has 1 life
    And the previous robot already has taken 10 damage

    When a turn is played
    Then the previous robot should be destroyed
    Then the previous robot should have 0 lives

    When a round is ended
    And a round is started

    Then the previous robot should be destroyed
    And the game should not await input