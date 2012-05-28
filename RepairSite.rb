require_relative 'utils'
require_relative 'BoardElement'

class RepairSite < BoardElement
  def initialize(x, y)
    super(x, y, :west)
    @phases = [700]
  end

  def act(game, turn, phase)
    # check for a robot
    robot = game.first_of_at(@x, @y, Robot)

    if not robot.nil? then
      robot.save

      if turn == 4 then
        robot.heal 1       
      end
    end
  end
end
