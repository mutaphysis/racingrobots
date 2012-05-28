require_relative 'utils'
require_relative 'BoardElement'

class Wall < BoardElement
  def initialize(x, y, direction)
    super(x, y, direction)
  end
end
