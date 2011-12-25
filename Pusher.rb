require_relative 'utils'
require_relative 'BoardElement'

class Pusher < BoardElement  
  def initialize(x, y, direction)
    super(x, y, direction)
    
    @phases = [400]
  end
  
  def act(game, turn, phase)   
    game.push(@x, @y, @direction)            
  end
end
