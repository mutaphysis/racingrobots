require 'rspec'

require_relative '../../Game'

# Helper functions

def query_robot(id)
  number = /(\d+)(?:st|nd|rd|th)/.match(id)
  
  unless number.nil? then
    robot_id = number[0]
    return @game.get_robot(robot_id.to_i - 1) 
  end
    
  case id    
  when "previous" then
    @robot
  else
    nil
  end
end

# Givens

Given /^there is a board:$/ do |table|
  # table is a Cucumber::Ast::Table
  @game = Game.create(table.raw)
end

Given /^there is a robot at (\d+), (\d+)$/ do |x, y|
  @robot = @game.create_robot()
  @game.place_robot(@robot, x.to_i, y.to_i)
end

Given /^there is a robot at (\d+), (\d+) facing (\w+)$/ do |x, y, facing|
  @robot= @game.create_robot()
  @game.place_robot(@robot, x.to_i, y.to_i, $key_direction[facing[0]])
end

Given /^there are (\d+) robots$/ do |num|  
  num.to_i.times do |i|
    @game.create_robot()
  end
end

Given /^the (\w+) robots program is:$/ do |robot_id, table|
  @robot = @game.get_robot(robot_id.to_i - 1)
  program = table.raw[0].collect do |value|    
    values = value.split(":")
    Card.new(values[0].to_sym, values[1].to_i)
  end
  
  @robot.program = program
end

Given /^the (\w+) robot already has taken (\d+) damage$/ do |robot_id, damage_taken|
  @robot = query_robot(robot_id)
  @robot.damage_taken = damage_taken.to_i
end

Given /^the (\w+) robot was already saved at (\d+), (\d+)$/ do |robot_id, x, y|
  @robot = query_robot(robot_id)
  @robot.save(x.to_i, y.to_i)
end

# Modifiying the robots

When /^the (\w+) robot chooses the program$/ do |robot_id, cards|
  @robot = query_robot(robot_id)
  program = cards.raw[0].collect do |card_id|
    @robot.cards[card_id.to_i]
  end
  @robot.program = program
end

When /^the (\w+) robot choses to face (\w+)$/ do |robot_id, facing|
  @robot = query_robot(robot_id)
  @robot.direction = $key_direction[facing[0]]
end


# Advancing the game

When /^the game is started$/ do
  @game.begin_game()
end

When /^a turn is played$/ do
  @game.step_turn
end

When /^a round is played$/ do
  @game.step_round
end

When /^a round is started$/ do
  @game.begin_round
end

When /^a round is ended$/ do
  @game.end_round
end

### Checks

Then /^there should be (a|no) ([A-Z]\w*) at (\d+), (\d+)$/ do |negate, type_name, x, y|
  type = Kernel.const_get(type_name)
  object = @game.first_of_at(x.to_i, y.to_i, type)
  
  if negate == "no" then 
    object.should == nil
  else
    object.should_not == nil
  end  
end

Then /^there should be (a|no) robot at (\d+), (\d+)$/ do |negate, x, y|
  @robot = @game.first_of_at(x.to_i, y.to_i, Robot)
    
  if negate == "no" then 
    @robot.should == nil
  else
    @robot.should_not == nil
  end
end

Then /^the round (can|cannot) be continued$/ do |continue|
  @game.round_ready?.should == (continue == "can") 
end

Then /^the (\w+) robot should have (\d+) program cards$/ do |robot_id, cards|
  @robot = query_robot(robot_id)
  @robot.cards.length.should == cards.to_i
end

Then /^the (\w+) robot should not be saved$/ do |robot_id|
  @robot = query_robot(robot_id)
  @robot.saved_at.should == nil
end

Then /^the (\w+) robot should be saved at (\d+), (\d+)$/ do |robot_id, x, y|
  @robot = query_robot(robot_id)
  @robot.saved_at.should_not == nil
  @robot.saved_at.x.should == x.to_i
  @robot.saved_at.y.should == y.to_i
end

Then /^the (\w+) robot should( not){0,1} be destroyed$/ do |robot_id, negated|
  @robot = query_robot(robot_id)
  @robot.destroyed.should == (negated ? false : true)
end

Then /^the (\w+) robot should have taken (\d+) damage$/ do |robot_id, damage_taken|
  @robot = query_robot(robot_id)
  @robot.damage_taken.should == damage_taken.to_i
end

Then /^the (\w+) robot should be at (\d+), (\d+) facing (\w+)$/ do |robot_id, x, y, facing|
  @robot = query_robot(robot_id)
  @robot.x.should == x.to_i
  @robot.y.should == y.to_i
  @robot.destroyed.should == false
  @robot.direction.should === $key_direction[facing[0]]
end