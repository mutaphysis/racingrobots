require_relative 'utils'
require_relative 'BoardElement'

class Pit < BoardElement
  def initialize(x, y)
    super(x, y, :west)
  end
end
