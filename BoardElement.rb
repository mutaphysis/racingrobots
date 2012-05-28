class BoardElement
  attr_accessor :x, :y, :direction
  attr_reader :phases
  
  def initialize(x, y, direction)
    @phases = []
    @x = x
    @y = y    
    @direction = direction    
  end

  def act(game, turn, phase)
  end
end
