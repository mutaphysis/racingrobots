require_relative 'BoardElement'

class Robot < BoardElement
  attr_reader :id
  attr_accessor :program, :destroyed
  
  def initialize(x, y, direction, id)
    super(x, y, direction)
    @id = id
    @program = []
    @destroyed = false
    
    @phases = [100, 600, 700]
  end

  def act(game, turn, phase)
    return if @destroyed
    
    case phase
    when 100 then
      run_program(game, turn)
    end
  end    
  
  def run_program(game, turn)
    card = @program[turn]
    
    if not card.nil? then
      card.act(game, self)
    end
  end
end
