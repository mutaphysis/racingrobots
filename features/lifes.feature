Feature: Lifes
  Each robot gets three life tokens
  Each time a robot is destroyed a life token is taken away
  If a robot is destroyed when having no life tokens, he is removed from the game and does not respawn anymore

  Scenario: A fresh robot has three life tokens
    Given there is a board:
      | |
    And there is a robot at 0, 0 facing west
    Then the previous robot should have 3 lifes

