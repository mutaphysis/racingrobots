require_relative 'BoardElement'

class Robot < BoardElement
  attr_reader :id, :saved_at
  attr_accessor :program, :destroyed, :damage_taken, :cards
    
  def initialize(x, y, direction, id)
    super(x, y, direction)
    @id = id
    @cards = []
    @program = []
    @destroyed = false
    @damage_taken = 0
    @saved_at = nil
        
    @phases = [100, 600, 700]
  end
  
  def act(game, turn, phase)
    return if @destroyed
    
    case phase
    when 100 then
      run_program(game, turn)
    when 600 then
      game.shoot_laser(@x, @y, @direction, :exclude_first)
    when 700 then
      save_point = game.first_of_at(@x, @y, RepairSite)
      @saved_at = Point.new(@x, @y)
    end    
  end    
  
  def run_program(game, turn)
    card = @program[turn]
    
    if not card.nil? then
      card.act(game, self)
    end
  end
end
