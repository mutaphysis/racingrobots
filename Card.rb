initial_priority = 10
priority_increment = 10

seed_order = [:uturn, :rotateleft, :rotateright, :backup, :moveone, :movetwo, :movethree]
seed = {:uturn => 6, :rotateleft => 18, :rotateright => 18, :backup => 6, :moveone => 18, :movetwo => 12, :movethree => 6 }

$cards = []

class Card
  attr_reader :type, :priority
  
  def initialize(type, priority)
    @type = type
    @priority = priority 
  end
  
  def act(game, robot)
    case @type
    when :uturn then 
      direction = $mirror_direction[robot.direction]
      game.add_robot_action(robot, robot.x, robot.y, direction) 
    when :rotateleft then 
      direction = $rotate_direction[:left][robot.direction]
      game.add_robot_action(robot, robot.x, robot.y, direction) 
    when :rotateright then 
      direction = $rotate_direction[:right][robot.direction]
      game.add_robot_action(robot, robot.x, robot.y, direction) 
    when :moveone then 
      #game.add
    end
  end
end

seed_order.each do |k|  
  (0..seed[k]).each do |n|
    $cards << Card.new(k, ($cards.length * priority_increment + initial_priority))
  end
end