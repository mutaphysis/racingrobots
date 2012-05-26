require 'rspec'

require_relative '../../Game'


Given /^there is a board:$/ do |table|
  # table is a Cucumber::Ast::Table
  @game = Game.create(table.raw)
end

Given /^there is a robot at (\d+), (\d+)$/ do |x, y|
  r = @game.create_robot()
  @game.place_robot(r, x.to_i, y.to_i)
end

Given /^there is a robot at (\d+), (\d+) facing (\w+)$/ do |x, y, facing|
  r = @game.create_robot()
  @game.place_robot(r, x.to_i, y.to_i, $key_direction[facing[0]])
end

Given /^there are (\d+) robots$/ do |num|  
  num.to_i.times do |i|
    @game.create_robot()
  end
end

Given /^the (\d+)(?:st|nd|rd|th) robots program is:$/ do |robot_id, table|
  robot = @game.get_robot(robot_id.to_i - 1)
  program = table.raw[0].collect do |value|    
    values = value.split(":")
    Card.new(values[0].to_sym, values[1].to_i)
  end
  
  robot.program = program
end

Given /^the (\d+)(?:st|nd|rd|th) robot already has taken (\d+) damage$/ do |robot_id, damage_taken|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.damage_taken = damage_taken.to_i
end


# Modifiying the robots

When /^the (\d+)(?:st|nd|rd|th) robot chooses the program$/ do |robot_id, cards|
  robot = @game.get_robot(robot_id.to_i - 1)
  program = cards.raw[0].collect do |card_id|
    robot.cards[card_id.to_i]
  end
  robot.program = program
end

When /^the (\d+)(?:st|nd|rd|th) robot choses to face (\w+)$/ do |robot_id, facing|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.direction = $key_direction[facing[0]]
end


# Advancing the game

When /^the game is started$/ do
  @game.begin_game()
end

When /^a turn is played$/ do
  @game.step_turn
end

When /^a round is played$/ do
  @game.round_turn
end

When /^a round is started$/ do
  @game.begin_round
end

When /^a round is ended$/ do
  @game.end_round
end

### Checks

Then /^there should be a ([A-Z]\w*) at (\d+), (\d+)$/ do |type_name, x, y|
  type = Kernel.const_get(type_name)
  @game.first_of_at(x.to_i, y.to_i, type).should_not == nil
end

Then /^there should be no ([A-Z]\w*) at (\d+), (\d+)$/ do |type_name, x, y|
  type = Kernel.const_get(type_name)
  @game.first_of_at(x.to_i, y.to_i, type).should == nil
end

Then /^the round (can|cannot) be continued$/ do |continue|
  @game.round_ready?.should == (continue == "can") 
end

Then /^the (\d+)(?:st|nd|rd|th) robot has (\d+) program cards$/ do |robot_id, cards|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.cards.length.should == cards.to_i
end

Then /^the (\d+)(?:st|nd|rd|th) robot is not saved$/ do |robot_id|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.saved_at.should == nil
end

Then /^the (\d+)st robot is saved at (\d+), (\d+)$/ do |robot_id, x, y|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.saved_at.x.should == x.to_i
  robot.saved_at.y.should == y.to_i
end

Then /^the (\d+)(?:st|nd|rd|th) robot is( not){0,1} destroyed$/ do |robot_id, negated|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.destroyed.should == (negated ? false : true)
end

Then /^the (\d+)(?:st|nd|rd|th) robot has taken (\d+) damage$/ do |robot_id, damage_taken|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.damage_taken.should == damage_taken.to_i
end

Then /^the (\d+)(?:st|nd|rd|th) robot is at (\d+), (\d+) facing (\w+)$/ do |robot_id, x, y, facing|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.x.should == x.to_i
  robot.y.should == y.to_i
  robot.destroyed.should == false
  robot.direction.should === $key_direction[facing[0]]
end