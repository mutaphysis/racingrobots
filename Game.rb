require_relative 'utils'
require_relative 'Card'
require_relative 'Robot'
require_relative 'Conveyor'
require_relative 'Laser'
require_relative 'Gear'
require_relative 'Pit'
require_relative 'Pusher'
require_relative 'Wall'
require_relative 'BoardElement'
require_relative 'RepairSite'
require_relative 'SpawnPoint'

# Helper function to convert String description into real tile instance
def parse_fields(description, x, y)
  fields = []

  descriptions = description.split(' ')

  descriptions.each do |fieldDescription|
    case fieldDescription[0]
      when 'C'
        express = !fieldDescription.index('*').nil?
        direction = DIRECTION_SHORT_MAP[fieldDescription[1]]
        turn_from_left = !fieldDescription.index('l').nil?
        turn_from_right = !fieldDescription.index('r').nil?

        fields << Conveyor.new(x, y, direction, express, turn_from_left, turn_from_right)
      when 'G'
        rotation = ROTATION_SHORT_MAP[fieldDescription[1]]
        fields << Gear.new(x, y, rotation)
      when 'P'
        direction = DIRECTION_SHORT_MAP[fieldDescription[1]]
        fields << Pusher.new(x, y, direction)
      when 'L'
        direction = DIRECTION_SHORT_MAP[fieldDescription[1]]
        fields << Laser.new(x, y, direction)
      when 'W'
        direction = DIRECTION_SHORT_MAP[fieldDescription[1]]
        fields << Wall.new(x, y, direction)
      when '_'
        fields << Pit.new(x, y)
      when 'R'
        fields << RepairSite.new(x, y)
      when 'S'
        id = fieldDescription[1].to_i
        fields << SpawnPoint.new(x, y, id)
      else
        fail "found non matching fieldDescription"
    end
  end

  fields
end

# Actions that happen following a priority, eg. moving and turning
class SequentialAction
  attr_reader :priority

  def initialize(robot, priority, distance, direction)
    @robot = robot
    @priority = priority
    @distance = distance
    @direction = direction
  end

  def act(game)
    if @distance != 0
      game.move_robot(@robot, @distance)
    end
    unless @direction.nil?
      game.update_robot(@robot, @robot.x, @robot.y, @direction)
    end
  end
end

# Actions that happen at the same time, eg. being moved by a conveyor (conflicts can happen)
#noinspection RubyInstanceVariableNamingConvention
class ParallelAction
  attr_reader :robot, :x, :y

  def initialize(robot, x, y, direction)
    @robot = robot
    @x = x
    @y = y
    @direction = direction
  end

  def undo()
    @x = @robot.x
    @y = @robot.y
    @direction = @robot.direction
  end

  def act(game)
    game.update_robot(@robot, @x, @y, @direction)
  end

  def ==(object)
    object.equal?(self) ||
        (object.instance_of?(self.class) &&
            object.x == @x &&
            object.y == @y)
  end
end

class Game
  attr_accessor :round, :turn, :phase, :board, :robots

  def initialize()
    @round = 0
    @turn = -1
    @phase = 0
    @robots = []
    @board = []
    @cards = Card.build_game_cards

    @parallel_action_queue = []
    @sequential_action_queue = []
  end

  # Create a board from a 2d array of tile definitions
  def setup_board(rows)
    y = 0
    rows.collect do |row|
      @board[y] = []
      x = 0
      row.collect do |item|
        #p "added at #{x} #{y}"
        @board[y][x] = parse_fields(item, x, y)
        x += 1
      end
      y += 1
    end

    self
  end

  def begin_game
    spawn_points = find_all_of(SpawnPoint)
    spawn_points.shuffle!

    # todo sanity check if there are any robots
    # todo sanity check if there more robots than spawnpoints

    @robots.each do |robot|
      spawn_point = spawn_points.pop
      # still no direction chosen, players need to do this as the next step
      place_robot(robot, spawn_point.x, spawn_point.y, :undefined)
      robot.save

      robot.awaits_input :choose_initial_direction
    end
  end

  def continue
    # \ game
    #   loop while not game over conditions, next round
    #   \ round
    #     wait for choosing starting direction
    #     wait for choosing respawn position
    #     wait for choosing respawn direction
    #     loop through all 5 turns
    #     \ turn
    #       wait for choosing program cards
    #       loop through all registered phases
    #       \ phase
    #         loop actions in this phase
    #       / phase
    #     / turn
    #   / round
    # / game

    if turn == -1
      #p "begin_round"
      begin_round()
    elsif turn == 5
      #p "end_round"
      end_round()
    else
      #p "step_turn"
      step_turn()
    end

    continue() unless awaits_input?
  end

  def step_round
    begin_round()
    5.times do
      step_turn()
    end
    end_round()
  end

  def begin_round
    @turn = 0

    # recreate damaged robots from last save
    @robots.each do |robot|
      if robot.destroyed?
        robot.restore
        @board[robot.y][robot.x] << robot

        # TODO handle two robots respawning at the same position
        robot.awaits_input :choose_respawn_direction
      end
    end

    # shuffle cards and hand out to robots
    cards = @cards.shuffle()

    # hand each robot a movement card
    @robots.each do |robot|
      hand = cards.take(9 - robot.damage_taken)
      robot.cards = hand
      robot.awaits_input :choose_program_cards
    end
  end

  def end_round
    @turn = -1
    @round += 1

    @robots.each do |robot|
      if robot.destroyed? && robot.lives <= 0
          @robots.delete robot
      end
    end
  end

  def awaited_input
    @robots.collect { |r| r.awaited_input }.flatten.uniq
  end

  def awaits_input?
    @robots.inject(false) { |last, r| last || r.waiting? }
  end

  def step_turn
    phases = {}

    # collect phases
    @board.each do |row|
      row.each do |column|
        column.each do |item|
          item.phases.each do |phase|
            if phases[phase].nil?
              phases[phase] = [item]
            else
              phases[phase] << item
            end
          end
        end
      end
    end

    phases.sort.map do |phase, items|
      @parallel_action_queue = []
      @sequential_action_queue = []

      items.each do |item|
        item.act(self, @turn, phase)
      end

      # get robots off the board
      @parallel_action_queue.each do |action|
        robot = action.robot
        @board[robot.y][robot.x].delete(robot)
      end

      # undo action that move on a non moving robot
      @parallel_action_queue.each do |action|
        robot = first_of_at(action.x, action.y, Robot)

        unless robot.nil?
          action.undo()
        end
      end

      # undo all invalid (moving two robots to the same position) parallel actions
      check_invalid = false
      begin
        check_invalid = false
        @parallel_action_queue.combination(2) do |combination|
          first = combination[0]
          second = combination[1]

          # actions that move to the same position should be reversed
          if first == second
            first.undo()
            second.undo()
            check_invalid = true
          end
        end
      end while check_invalid

      # execute all valid parallel actions
      @parallel_action_queue.each do |action|
        action.act(self)
      end

      # sort sequential action by priority
      @sequential_action_queue.sort! { |a1, a2| a2.priority <=> a1.priority }
      @sequential_action_queue.each do |action|
        action.act(self)
      end

      # remove robots with enough damage from the field
      @robots.each do |robot|
        if !robot.destroyed? && robot.damage_taken > 9
          robot.destroy()
          @board[robot.y][robot.x].delete(robot)
        end
      end
    end

    @turn += 1

    self
  end

  def create_robot()
    robot = Robot.new(-1, -1, direction=:undefined, @robots.length)
    @robots[@robots.length] = robot
    robot
  end

  def place_robot(robot, x, y, direction=:west)
    robot.direction = direction
    robot.x = x
    robot.y = y
    @board[y][x] << robot
    robot
  end

  def add_parallel_robot_action(robot, x, y, direction)
    @parallel_action_queue << ParallelAction.new(robot, x, y, direction)
    @parallel_action_queue.last
  end

  def add_sequential_robot_action(robot, priority, distance, direction=nil)
    @sequential_action_queue << SequentialAction.new(robot, priority, distance, direction)
    @sequential_action_queue.last
  end

  def move_robot(robot, distance)
    direction = robot.direction

    if distance < 0
      direction = Direction.mirror(direction)
    end
    distance = distance.abs

    new_coord = Point.new(robot.x, robot.y)
    distance.times do
      next_coord = Direction.offset_coordinate(new_coord.x, new_coord.y, direction)
      blocked = check_blocked(new_coord.x, new_coord.y, next_coord.x, next_coord.y, direction)
      break if blocked

      new_coord = next_coord

      # even if this is an edge or a pit, we can push on to it even if the current robot will die there, anything else reaching this new_coord is already dead
      self.push(new_coord.x, new_coord.y, direction)
      update_robot(robot, new_coord.x, new_coord.y, robot.direction)
      break if robot.destroyed?
    end
  end

  def check_blocked(x, y, x2, y2, direction, mode=nil)
    # check for a wall preventing leaving the current field
    wall = @board[y][x].find { |item| item.instance_of?(Wall) && item.direction == direction }
    return true unless wall.nil?

    # if after an edge, no need to continue looking for things there
    return false if x2 < 0 || y2 < 0 || y2 >= @board.length || x2 >= @board[y2].length

    # check for a wall preventing entering the next field
    direction2 = Direction.mirror(direction)
    wall = @board[y2][x2].find { |item| item.instance_of?(Wall) && item.direction == direction2 }
    return true unless wall.nil?

    if mode != :no_recursive
      # if there is a robot on the next field, we might push it into a wall
      robot = @board[y2][x2].find { |item| item.instance_of? Robot }

      unless robot.nil?
        next_coord = Direction.offset_coordinate(x2, y2, direction)
        # continue checking recursively
        return self.check_blocked(x2, y2, next_coord.x, next_coord.y, direction)
      end
    end

    false
  end

  def shoot_laser(x, y, direction, options=nil)
    new_coord = Point.new(x, y)
    target = nil

    if options == :exclude_first
      next_coord = Direction.offset_coordinate(new_coord.x, new_coord.y, direction)
      return if check_blocked(new_coord.x, new_coord.y, next_coord.x, next_coord.y, direction, :no_recursive)
      new_coord = next_coord
    end

    begin
      break if new_coord.x < 0 || new_coord.y < 0 || new_coord.y >= @board.length || new_coord.x >= @board[new_coord.y].length

      next_coord = Direction.offset_coordinate(new_coord.x, new_coord.y, direction)

      break if check_blocked(new_coord.x, new_coord.y, next_coord.x, next_coord.y, direction, :no_recursive)

      target = first_of_at(new_coord.x, new_coord.y, Robot)
      new_coord = next_coord
    end while target.nil?

    if target
      target.damage_taken += 1
    end
  end

  def push(x, y, direction)
    pushed_robot = self.first_of_at(x, y, Robot)
    unless pushed_robot.nil?
      pushed_coord = Direction.offset_coordinate(x, y, direction)
      self.push(pushed_coord.x, pushed_coord.y, direction)
      update_robot(pushed_robot, pushed_coord.x, pushed_coord.y, pushed_robot.direction)
    end
  end

  def update_robot(robot, x, y, direction)
    @board[robot.y][robot.x].delete(robot)

    # driving of the edge destroys
    if x < 0 || y < 0 || y >= @board.length || x >= @board[y].length
      robot.destroy()
      return
    end

    # driving in a pit destroys
    pit = self.first_of_at(x, y, Pit)
    unless pit.nil?
      robot.destroy()
      return
    end

    robot.x = x
    robot.y = y
    robot.direction = direction

    @board[y][x] << robot
  end

  def get_robot(id)
    @robots[id]
  end

  # creates an enumerator for all the tiles on the board
  def each_tile
    Enumerator.new do |yielder|
      @board.each do |column|
        column.each do |tiles|
          tiles.each do |tile|
            yielder.yield(tile)
          end
        end
      end
    end
  end

  def find_all_of(type)
    each_tile.find_all { |item| item.instance_of? type }
  end

  def first_of_at(x, y, type)
    return nil if x < 0 || y < 0 || y >= @board.length || x >= @board[y].length
    @board[y][x].find { |item| item.instance_of? type }
  end

  def get_at(x, y)
    @board[y][x]
  end

  def self.create(data)
    game = Game.new
    game.setup_board(data)

    game
  end
end