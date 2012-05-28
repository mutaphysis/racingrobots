require_relative 'utils'
require_relative 'BoardElement'

class Gear < BoardElement  
  def initialize(x, y, rotation)
    super(x, y, :west)
    
    @rotation = rotation  
    @phases = [500]
  end
  
  def act(game, turn, phase)
    # there can only be one robot here anyway
    robot = game.first_of_at(@x, @y, Robot)    
    
    unless robot.nil?
      direction = $rotate_direction[@rotation][robot.direction]   
      game.add_parallel_robot_action(robot, robot.x, robot.y, direction)            
    end
  end
end
