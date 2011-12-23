mirror_direction = {'w' => 'e', 'n' => 's', 'e' => 'w', 's' => 'n' }
rotate_direction = { 'l' => {'w' => 'n', 'n' => 'e', 'e' => 's', 's' => 'w' }, 
                     'r' =>  {'w' => 's', 's' => 'e', 'e' => 'n', 'n' => 'w' }}

def parseField(fieldDescription, x, y)
  fields = []
  case fieldDescription[0]
    when 'C' then    
      fields << Conveyor.new(x, y, fieldDescription[1], fieldDescription[fieldDescription.length - 1] === '*')
    else
  end
  
  fields
end

class Conveyor 
  def initialize(x, y, direction, express)
    @x = x
    @y = y    
    @direction = direction 
    @express = express   
    
    if @express then @phases = [200, 300] 
    else @phases = [300]  
    end
  end
  
  def act(game)
    # there can only be one robot there anyway
    robot = game.get_typed_at(@x, @y, Robot)[0]    
    
    if not robot.nil? then
      case @direction
        when 'e' then
          robot.x = robot.x + (@express ? 2 : 1)
        when 'w' then
          robot.x = robot.x - (@express ? 2 : 1)
        when 'n' then          
          robot.y = robot.y - (@express ? 2 : 1)
        when 's' then          
          robot.y = robot.y + (@express ? 2 : 1)
        else
      end
    end
  end
end

class Robot
  def initialize(x, y, facing, id)
    @x = x
    @y = y    
    @facing = facing
  end
  
  attr_accessor :x, :y, :facing
  
  def act(game)
  end
end

class Game
  def initialize()
    @robots = []
    @board = []
  end
  
  def setup_board(rows)
    x = 0
    y = 0
    
    rows.collect do |row|       
      @board[y] = []
      x = 0
      row.collect do |item| 
        #p "added at #{x} #{y}"
        @board[y][x] = parseField(item, x, y)
        x += 1
      end
      y += 1      
    end
    
    self
  end
  
  def step_turn
    y = 0    
    @board.each do |row|
      x = 0
      row.each do |column|         
        column.each do |item| 
          item.act(self)
        end          
      end
    end
  end
  
  def create_robot(x, y, facing)
    robot = Robot.new(x, y, facing, @robots.length)
    @robots[@robots.length] = robot
    @board[y][x] << robot
  end
  
  def get_robot(id)
    @robots[id]
  end
  
  def get_typed_at(x, y, type)
    @board[y][x].find_all{|robot| robot.instance_of? type}
  end
  
  def get_at(x, y)
    @board[y][x]
  end
    
  def self.create(data)
    game = Game.new
    game.setup_board(data)
  end
end