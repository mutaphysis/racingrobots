require 'rspec'

require_relative '../../Game'

# Helper functions

def query_robot(id)
  number = /(\d+)(?:st|nd|rd|th)/.match(id)

  unless number.nil?
    robot_id = number[0]
    return @game.get_robot(robot_id.to_i - 1)
  end

  case id
    when "previous"
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

Given /^there is a destroyed robot saved at (\d+), (\d+)$/ do |x, y|
  @robot = @game.create_robot()
  @robot.damage_taken = 10
  @robot.destroy()
  @robot.save(x.to_i, y.to_i)
end

Given /^there is a robot at (\d+), (\d+) facing (\w+)$/ do |x, y, facing|
  @robot= @game.create_robot()
  @game.place_robot(@robot, x.to_i, y.to_i, DIRECTION_SHORT_MAP[facing[0]])
end

Given /^there (?:are|is) (\d+) robots?$/ do |num|
  num.to_i.times do |_|
    @game.create_robot()
  end
end

Given /^the (\w+) robots program is:$/ do |robot_id, table|
  @robot = @game.get_robot(robot_id.to_i - 1)
  program = table.raw[0].collect do |value|
    values = value.split(":")
    Card.new(values[0].to_sym, values[1].to_i)
  end

  # inject illegal program
  @robot.instance_exec(program) { |program| @program = program }
end

Given /^the (\w+) robot already has taken (\d+) damage$/ do |robot_id, damage_taken|
  @robot = query_robot(robot_id)
  @robot.damage_taken = damage_taken.to_i
end

Given /^the (\w+) robot was already saved at (\d+), (\d+)$/ do |robot_id, x, y|
  @robot = query_robot(robot_id)
  @robot.save(x.to_i, y.to_i)
end

Given /^the (\w+) robot has (\d+) (?:life|lives)/ do |robot_id, lives|
  @robot = query_robot(robot_id)
  # inject lives
  @robot.instance_exec(lives.to_i) { |lives| @lives = lives }
end

Given /^the (\w+) robot has received the following cards$/ do |robot_id, table|
  @robot = @game.get_robot(robot_id.to_i - 1)
  @robot.cards = table.raw[0].collect do |value|
    values = value.split(":")
    Card.get_card(values[0].to_sym, values[1].to_i)
  end
end

# Modifiying the robots

When /^the (\w+) robot chooses the program$/ do |robot_id, cards|
  @robot = query_robot(robot_id)
  program = cards.raw[0].collect do |card_id|
    @robot.cards[card_id.to_i]
  end
  @robot.choose_program(program)
end

When /^the (\w+) robot chooses a random program$/ do |robot_id|
  @robot = query_robot(robot_id)
  @robot.choose_program(@robot.cards.shuffle.take(5))
end

When /^the (\w+) robot chooses an empty program$/ do |robot_id|
  @robot = query_robot(robot_id)
  # inject illegal program
  @robot.instance_exec() { @program = [] }
  @robot.finished_input :choose_program_cards
end

When /^the (\w+) robot choses to start facing (\w+)$/ do |robot_id, facing|
  @robot = query_robot(robot_id)
  @robot.direction = DIRECTION_SHORT_MAP[facing[0]]
  @robot.finished_input :choose_initial_direction
end

When /^the (\w+) robot choses to respawn facing (\w+)$/ do |robot_id, facing|
  @robot = query_robot(robot_id)
  @robot.direction = DIRECTION_SHORT_MAP[facing[0]]
  @robot.finished_input :choose_respawn_direction
end


# Advancing the game

When /^the game is continued/ do
  @game.continue()
end

When /^the game is started$/ do
  @game.begin_game()
end

When /^a turn is played$/ do
  @game.turn = 0
  @game.step_turn
end

When /^turn (\d+) is played$/ do |num|
  @game.turn = num.to_i
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

  if negate == "no"
    object.should == nil
  else
    object.should_not == nil
  end
end

Then /^there should be (a|no) robot at (\d+), (\d+)$/ do |negate, x, y|
  @robot = @game.first_of_at(x.to_i, y.to_i, Robot)

  if negate == "no"
    @robot.should == nil
  else
    @robot.should_not == nil
  end
end

Then /^the game should (not )?await input$/ do |negated|
  @game.awaits_input?.should == (!negated)
end

Then /^the game should (not )?await the following input$/ do |negated, input_table|
  inputs = input_table.raw[0].collect do |value|
    value.to_sym
  end

  awaited_input = @game.awaited_input
  exists = false
  if negated
    exists = inputs.inject(false) { |last, input| last || awaited_input.include?(input) }
    exists.should == false
  else
    exists = inputs.inject(true) { |last, input| last && awaited_input.include?(input) }
    exists.should == true
  end
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

Then /^the (\w+) robot should( not)? be destroyed$/ do |robot_id, negated|
  @robot = query_robot(robot_id)
  @robot.destroyed?.should == (negated ? false : true)
end

Then /^the (\w+) robot should have taken (\d+) damage$/ do |robot_id, damage_taken|
  @robot = query_robot(robot_id)
  @robot.damage_taken.should == damage_taken.to_i
end

Then /^the (\w+) robot should be at (\d+), (\d+) facing (\w+)$/ do |robot_id, x, y, facing|
  @robot = query_robot(robot_id)
  @robot.x.should == x.to_i
  @robot.y.should == y.to_i
  @robot.destroyed?.should == false
  @robot.direction.should === DIRECTION_SHORT_MAP[facing[0]]
end

Then /^there should be (\d+) rounds? played$/ do |rounds|
  @game.round.should == rounds.to_i
end

Then /^there should be (\d+) turns? played$/ do |turns|
  @game.turn.should == turns.to_i
end

Then /^the (\w+) robot should have (\d+) (?:life|lives)$/ do |robot_id, lives|
  @robot = query_robot(robot_id)
  @robot.lives.should == lives.to_i
end

Then /^the (\w+) robot should (not )?fail choosing the following program$/ do |robot_id, negated, table|
  @robot = query_robot(robot_id)
  cards = table.raw[0].collect do |value|
    values = value.split(":")
    Card.get_card(values[0].to_sym, values[1].to_i)
  end

  if negated
    expect { @robot.choose_program(cards) }.should_not raise_error
  else
    expect { @robot.choose_program(cards) }.should raise_error
  end
end
