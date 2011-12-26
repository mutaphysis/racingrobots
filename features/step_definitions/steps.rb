require 'rspec'

require_relative '../../Game'

def mapfacing(facing) 
end

Given /^there is a board:$/ do |table|
  # table is a Cucumber::Ast::Table
  @game = Game.create(table.raw)
end

Given /^there is a robot at (\d+), (\d+)$/ do |x, y|
  @game.create_robot(x.to_i, y.to_i)
end

Given /^there is a robot at (\d+), (\d+) facing (\w+)$/ do |x, y, facing|
  @game.create_robot(x.to_i, y.to_i, $key_direction[facing[0]])
end

Given /^the (\d+)(?:st|nd|rd|th) robots program is:$/ do |robot_id, table|
  robot = @game.get_robot(robot_id.to_i - 1)
  program = table.raw[0].collect do |value|    
    values = value.split(":")
    Card.new(values[0].to_sym, values[1].to_i)
  end
  
  robot.program = program
end

When /^a turn is played$/ do
  @game.step_turn
end

Then /^the (\d+)(?:st|nd|rd|th) robot is destroyed$/ do |robot_id|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.destroyed.should == true
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