require_relative 'utils'
require_relative 'BoardElement'

class Laser < BoardElement  
  def initialize(x, y, direction)
    super(x, y, direction)
     
    @phases = [600]
  end
  
  def act(game, turn, phase)
    game.shoot_laser(@x, @y, @direction)
  end
  
end
