require_relative 'BoardElement'

class Robot < BoardElement
  attr_reader :id
  
  def initialize(x, y, direction, id)
    super(x, y, direction)
    @id = id
  end
end
