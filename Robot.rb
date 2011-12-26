require_relative 'BoardElement'

class Robot < BoardElement
  attr_reader :id
  attr_accessor :program, :destroyed, :damage_taken
  
  def initialize(x, y, direction, id)
    super(x, y, direction)
    @id = id
    @program = []
    @destroyed = false
    @damage_taken = 0
    
    @phases = [100, 600, 700]
  end

  def act(game, turn, phase)
    return if @destroyed
    
    case phase
    when 100 then
      run_program(game, turn)
    when 600 then
      game.shoot_laser(@x, @y, @direction, :exclude_first)        
    end
    
  end    
  
  def run_program(game, turn)
    card = @program[turn]
    
    if not card.nil? then
      card.act(game, self)
    end
  end
end
