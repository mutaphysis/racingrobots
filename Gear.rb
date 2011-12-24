require_relative 'utils'
require_relative 'BoardElement'

class Gear < BoardElement  
  def initialize(x, y, rotation)
    super(x, y, :west)
    
    @rotation = rotation  
    @phases = [500]
  end
  
  def act(game, phase)
    # there can only be one robot here anyway
    robot = game.get_typed_at(@x, @y, Robot).first    
    
    if not robot.nil? then    
      direction = $rotate_direction[@rotation][robot.direction]   
      game.add_robot_action(robot, robot.x, robot.y, direction)            
    end
  end
end
