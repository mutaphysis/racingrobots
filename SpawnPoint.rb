require_relative 'utils'
require_relative 'BoardElement'

class SpawnPoint < BoardElement
  attr_reader :id
  def initialize(x, y, id)
    @id = id
    super(x, y, :west)
  end
end
