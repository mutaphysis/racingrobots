require_relative 'BoardElement'

class Conveyor < BoardElement
  attr_reader :turnFromLeft
  
  def initialize(x, y, direction, express, turnFromLeft, turnFromRight)
    super(x, y, direction)
    
    @express = express   
    
    @turnFromLeft = turnFromLeft
    @turnFromRight = turnFromRight
    
    if @express then @phases = [200, 300] else @phases = [300]  
    end
  end
  
  def act(game, phase)
    # there can only be one robot here anyway
    robot = game.get_typed_at(@x, @y, Robot).first    
    
    if not robot.nil? then
      new_coord = offset_coordinate(robot.x, robot.y, @direction)
      direction = robot.direction          
      
      # blocked by a robot 
      obstacle = game.get_typed_at(new_coord[:x], new_coord[:y], Robot).first      
      return unless obstacle.nil?
      
      # if moved onto another conveyor, could be turned
      conveyor = game.get_typed_at(new_coord[:x], new_coord[:y], Conveyor).first
      if not conveyor.nil? then
        turn = conveyor.get_turn_from(@direction)
        
        if not turn.nil? then
          direction = $rotate_direction[turn][robot.direction]          
        end                
      end            
      
      game.add_robot_action(robot, new_coord[:x], new_coord[:y], direction)            
    end
  end
  
  def get_turn_from(direction)     
    if @turnFromLeft and direction == $rotate_direction[:right][@direction] then
      return :left
    end    
    
    if @turnFromRight and direction == $rotate_direction[:left][@direction] then
      return :right
    end
    
    nil
  end
end