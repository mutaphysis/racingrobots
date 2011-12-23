$key_direction = {"w" => :west, "n" => :north, "e" => :east, "s" => :south }
$mirror_direction = {:west => :east, :north => :south, :east => :west, :south => :north }
$rotate_direction = { :right => {:west => :north, :north => :east, :east => :south, :south => :west }, 
                      :left  => {:west => :south, :south => :east, :east => :north, :north => :west }}

def offset_coordinate(x, y, direction)
  case direction
    when :east then
      x = x + 1
    when :west then
      x = x - 1
    when :north then          
      y = y - 1
    when :south then          
      y = y + 1
    else
  end
  
  { :x => x, :y => y }
end

def parse_field(fieldDescription, x, y)
  fields = []
  case fieldDescription[0]
    when 'C' then    
      express = !fieldDescription.index('*').nil?
      direction = $key_direction[fieldDescription[1]]
      turnFromLeft = !fieldDescription.index('l').nil?
      turnFromRight = !fieldDescription.index('r').nil?
      
      fields << Conveyor.new(x, y, direction, express, turnFromLeft, turnFromRight)
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
  attr_reader :turnFromLeft
  
  def initialize(x, y, direction, express, turnFromLeft, turnFromRight)
    super(x, y, direction)
    
    @express = express   
    
    @turnFromLeft = turnFromLeft
    @turnFromRight = turnFromRight
    
    if @express then @phases = [200, 300] else @phases = [300]  
    end
  end
  
  def act(game, phase)
    # there can only be one robot here anyway
    robot = game.get_typed_at(@x, @y, Robot).first    
    
    if not robot.nil? then
      new_coord = offset_coordinate(robot.x, robot.y, @direction)
      direction = robot.direction
      # if moved onto another conveyor, could be turned
      conveyor = game.get_typed_at(new_coord[:x], new_coord[:y], Conveyor).first    
      if not conveyor.nil? then
        turn = conveyor.get_turn_from(@direction)
        
        if not turn.nil? then
          direction = $rotate_direction[turn][robot.direction]          
        end                
      end
      
      game.add_robot_action(robot, new_coord[:x], new_coord[:y], direction)            
    end
  end
  
  def get_turn_from(direction)     
    if @turnFromLeft and direction == $rotate_direction[:right][@direction] then
      return :left
    end    
    
    if @turnFromRight and direction == $rotate_direction[:left][@direction] then
      return :right
    end
    
    nil
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
    @action_queue = []
  end
  
  def setup_board(rows)
    x = 0
    y = 0
    
    rows.collect do |row|       
      @board[y] = []
      x = 0
      row.collect do |item| 
        #p "added at #{x} #{y}"
        @board[y][x] = parse_field(item, x, y)
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
      @action_queue = []      
      items.each do |item|
        item.act(self, phase)        
      end

      @action_queue.each do |action|
        self.update_robot(action[:robot], action[:x], action[:y], action[:direction])        
      end      
    end
    
    self
  end
  
  def create_robot(x, y, direction)
    robot = Robot.new(x, y, direction, @robots.length)
    @robots[@robots.length] = robot
    @board[y][x] << robot
    
    robot
  end
  
  def add_robot_action(robot, x, y, direction)
    @action_queue << {:robot => robot, :x => x, :y => y, :direction => direction }
  end
  
  def update_robot(robot, x, y, direction)       
    @board[robot.y][robot.x].delete(robot)        
                            
    robot.x = x
    robot.y = y
    robot.direction = direction
    
    @board[y][x] << robot
  end  
  
  def get_robot(id)
    @robots[id]
  end
  
  def get_typed_at(x, y, type)    
    if not @board[y].nil? and not @board[y][x].nil?
      return @board[y][x].find_all{|item| item.instance_of? type}
    else
      return []
    end
  end
  
  def get_at(x, y)
    @board[y][x]
  end
    
  def self.create(data)
    game = Game.new
    game.setup_board(data)
    
    game
  end
end