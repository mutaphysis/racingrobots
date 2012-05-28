[Rules]
* DONE: Program cards need to be shuffled and divided between robots at the beginning of a round
* DONE: Each robot gets 9-damage program cards
* DONE: A robot with 10 damage is destroyed, not only 9 damage (5 locked program cards are possible)
* DONE: Add initial spawning points for robots
* DONE: Each robot is randomly assigned a starting point
* DONE: Each robot is randomly assigned a starting point
* DONE: A robot has to chose a view direction before spawning
* DONE: Repair site repair a robot at the end of the turn
* DONE: Respawning: Add respawning on the next turn when destroying occured
* DONE: Respawning: A respawning robot has 2 damage tokens

* TODO: Complete rounds should be playable, not just turns
* TODO: Add turn/round logic with waiting for player input - eg. choosing program cards, choosing respawn point
* TODO: A round can only be played when all robots have programs assigned

* TODO: Each robot gets three Life tokens
* TODO: Add game over for a robot after all its life tokens are gone

* TODO: Respawning: If two or more robots would reenter play on the same space, they’re placed back on the board in the order they were destroyed.
* TODO: Respawning: The first robot that was destroyed gets the archive space, facing any direction that player chooses.
* TODO: Respawning: The player whose robot was destroyed next then chooses an empty adjacent space (looking orthogonally OR diagonally) and puts the robot on that space. That robot can face any direction that player chooses, except that there can’t be another robot in its line of sight 3 spaces away or closer.
* TODO: Respawning: Ignore all board elements except for pits when placing your robot in an adjacent space. You can’t start a turn with your robot in a pit. They suffer enough as it is.

* TODO: The robot last standing wins the game
* TODO: The game ends as tie if all robots die in the same turn

* TODO: Add race logic - multiple stops, the robot first visiting them all in order wins the game

* TODO: More than four damage lock program cards
* TODO: Locked program cards are not dealt in the next turn!!!

* TODO: Robots can turn off in the next round
* TODO: Robots that will be turned off, heal at the beginning of the next round, but don't take program cards
* TODO: Robots that will be turned off return their locked cards before the next round

* IGNORE: custom rule - No robot should receive only turn program cards (no movements)

	[Server]	
* TODO: Allow choosing program cards for a robot
* TODO: Validate choice of cards (only allow cards that were dealt to a certain player)
* TODO: Advance turn when all players have their cards chosen

* TODO: Have the notion of players and have robots assigned to them


