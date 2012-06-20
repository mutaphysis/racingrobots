require_relative 'utils'

class Card
  attr_reader :type, :priority

  def initialize(type, priority)
    @type = type
    @priority = priority
  end

  def to_s
    "#{@type}:#{@priority}"
  end

  def act(game, robot)
    case @type
      when :uturn
        direction = Direction.mirror(robot.direction)
        game.add_sequential_robot_action(robot, @priority, 0, direction)
      when :rotateleft
        direction = Direction.rotate_left(robot.direction)
        game.add_sequential_robot_action(robot, @priority, 0, direction)
      when :rotateright
        direction = Direction.rotate_right(robot.direction)
        game.add_sequential_robot_action(robot, @priority, 0, direction)
      when :backup
        game.add_sequential_robot_action(robot, @priority, -1)
      when :moveone
        game.add_sequential_robot_action(robot, @priority, 1)
      when :movetwo
        game.add_sequential_robot_action(robot, @priority, 2)
      when :movethree
        game.add_sequential_robot_action(robot, @priority, 3)
      else
        fail "unknown action"
    end
  end

  class << self; attr_reader :cards; end

  INITAL_PRIORITY = 10
  PRIORITY_INCREMENT = 10
  SEED_ORDER = [:uturn, :rotateleft, :rotateright, :backup, :moveone, :movetwo, :movethree]
  SEED = {:uturn => 6, :rotateleft => 18, :rotateright => 18, :backup => 6, :moveone => 18, :movetwo => 12, :movethree => 6}

  # class variable
  @cards = []

  # prefill the program card stack
  SEED_ORDER.each do |k|
    SEED[k].times do |_|
      @cards << Card.new(k, (@cards.length * PRIORITY_INCREMENT + INITAL_PRIORITY))
    end
  end

  def Card.build_game_cards
    Card.cards.dup
  end

  def Card.get_card(type, priority)
    card = Card.cards.find { |c| (c.type == type && c.priority == priority) }

    fail("Card not found #{type}:#{priority}") if card.nil?
    card
  end
end

