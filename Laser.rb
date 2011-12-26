require_relative 'utils'
require_relative 'BoardElement'

class Laser < BoardElement  
  def initialize(x, y, rotation)
    super(x, y, :west)
    
    @rotation = rotation  
    @phases = [600]
  end
  
  def act(game, turn, phase)

  end
end
