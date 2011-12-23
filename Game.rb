require_relative 'utils'
require_relative 'Robot'
require_relative 'Conveyor'
require_relative 'BoardElement'

def parse_fields(fieldDescription, x, y)
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
        @board[y][x] = parse_fields(item, x, y)
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
      
      # replace invalid actions       
      begin
        check_invalid = false
        @action_queue.combination(2) do |combination|
          first = combination[0]
          second = combination[1]
        
          if first[:x] === second[:x] and first[:y] === second[:y] then
            first[:x] = first[:robot].x
            first[:y] = first[:robot].y
            first[:direction] = first[:robot].direction

            second[:x] = second[:robot].x
            second[:y] = second[:robot].y
            second[:direction] = second[:robot].direction            
            check_invalid = true         
          end
        end
      end while check_invalid

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
    @action_queue.last
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