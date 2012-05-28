require_relative 'utils'
require_relative 'BoardElement'

class Pusher < BoardElement
  def initialize(x, y, direction)
    super(x, y, direction)

    @phases = [400]
  end

  def act(game, turn, phase)
    next_coord = offset_coordinate(@x, @y, @direction)
    blocked = game.check_blocked(@x, @y, next_coord.x, next_coord.y, direction)

    game.push(@x, @y, @direction) unless blocked
  end
end
