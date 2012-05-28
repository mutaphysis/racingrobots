require_relative 'utils'
require_relative 'BoardElement'

class Conveyor < BoardElement
  attr_reader :turn_from_left
  
  def initialize(x, y, direction, express, turn_from_left, turn_from_right)
    super(x, y, direction)
    
    @express = express   
    
    @turn_from_left = turn_from_left
    @turn_from_right = turn_from_right
    
    if @express then @phases = [200, 300] else @phases = [300]  
    end
  end
  
  def act(game, turn, phase)
    # there can only be one robot here anyway
    robot = game.first_of_at(@x, @y, Robot)    
    
    unless robot.nil?
      new_coord = offset_coordinate(robot.x, robot.y, @direction)
      direction = robot.direction
      
      return if game.check_blocked(@x, @y, new_coord.x, new_coord.y, @direction)
      
      # if moved onto another conveyor, could be turned
      conveyor = game.first_of_at(new_coord.x, new_coord.y, Conveyor)
      unless conveyor.nil?
        turn = conveyor.get_turn_from(@direction)
        
        unless turn.nil?
          direction = $rotate_direction[turn][robot.direction]          
        end                
      end            
      
      game.add_parallel_robot_action(robot, new_coord.x, new_coord.y, direction)
    end
  end
  
  def get_turn_from(direction)     
    if @turn_from_left and direction == $rotate_direction[:right][@direction] then
      return :left
    end    
    
    if @turn_from_right and direction == $rotate_direction[:left][@direction] then
      return :right
    end
    
    nil
  end
end