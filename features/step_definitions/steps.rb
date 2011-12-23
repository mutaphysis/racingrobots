require 'rspec'

# TODO including does look like shit
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "Game"))

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
  @game.create_robot(x.to_i, y.to_i, facing[0])
end


When /^a turn is played$/ do
  @game.step_turn
end

Then /^the (\d+)(?:st|nd|rd|th) robot is at (\d+), (\d+) facing (\w+)$/ do |robot_id, x, y, facing|
  robot = @game.get_robot(robot_id.to_i - 1)
  robot.x.should == x.to_i
  robot.y.should == y.to_i
  robot.facing.should === facing[0]
end