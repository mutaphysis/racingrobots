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

class BoardElement   
  attr_accessor :x, :y, :direction
  attr_reader :phases
  
  def initialize(x, y, direction)
    @phases = []
    @x = x
    @y = y    
    @direction = direction    
  end
  
  def act(game, phase)
  end  
end

class Conveyor < BoardElement
  def initialize(x, y, direction, express)
    super(x, y, direction)
    
    @express = express   
    
    if @express then @phases = [200, 300] 
    else @phases = [300]  
    end
  end
  
  def act(game, phase)
    # there can only be one robot here anyway
    robot = game.get_typed_at(@x, @y, Robot).first    
    
    if not robot.nil? then
      case @direction
        when 'e' then
          robot.x = robot.x + 1
        when 'w' then
          robot.x = robot.x - 1
        when 'n' then          
          robot.y = robot.y - 1
        when 's' then          
          robot.y = robot.y + 1
        else
      end
    end
  end
end

class Robot < BoardElement
  attr_reader :id
  
  def initialize(x, y, direction, id)
    super(x, y, direction)
    @id = id
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
    phases = {};
    
    # collect phases    
    @board.each do |row|    
      row.each do |column|         
        column.each do |item| 
          item.phases.each do |phase|
            if phases[phase].nil? then              
              phases[phase] = [item]
            else
              phases[phase] << item
            end
          end
        end          
      end
    end
    
    
    phases.sort.map do |phase, items|
      items.each do |item|
        item.act(self, phase)
      end
    end
    
  
  end
  
  def create_robot(x, y, direction)
    robot = Robot.new(x, y, direction, @robots.length)
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