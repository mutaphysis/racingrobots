require_relative 'utils'
require_relative 'BoardElement'

class Hole < BoardElement  
  def initialize(x, y)
    super(x, y, :west)
  end
end
