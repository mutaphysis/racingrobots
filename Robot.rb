require_relative 'BoardElement'

class Robot < BoardElement
  attr_reader :id
  attr_accessor :program
  
  def initialize(x, y, direction, id)
    super(x, y, direction)
    @id = id
    @program = []
  end
  
end
