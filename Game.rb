require_relative 'utils'
require_relative 'Card'
require_relative 'Robot'
require_relative 'Conveyor'
require_relative 'Laser'
require_relative 'Gear'
require_relative 'Pit'
require_relative 'Pusher'
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
    when 'G' then
      rotation = $key_rotation[fieldDescription[1]]
      fields << Gear.new(x, y, rotation)
    when 'P' then
      direction = $key_direction[fieldDescription[1]]
      fields << Pusher.new(x, y, direction)  
    when 'L' then
      direction = $key_direction[fieldDescription[1]]
      fields << Laser.new(x, y, direction)         
    when '_' then
      fields << Pit.new(x, y)       
  end
    
  fields
end

class Game  
  def initialize()
    @turn = 0
    @robots = []
    @board = []
    @parallel_action_queue = []
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
      @parallel_action_queue = []   
      @sequential_action_queue = []
         
      items.each do |item|
        item.act(self, @turn, phase)        
      end
      
      # sort sequential action by priority
      @sequential_action_queue.sort! {|x,y| y[:priority] <=> x[:priority] }
      
      # replace invalid parallel actions       
      begin
        check_invalid = false
        @parallel_action_queue.combination(2) do |combination|
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

      @parallel_action_queue.each do |action|
        self.update_robot(action[:robot], action[:x], action[:y], action[:direction])        
      end
      
      @sequential_action_queue.each do |action|
        self.move_robot(action[:robot], action[:distance])
      end
      
      @robots.each do |robot|
        if not robot.destroyed and robot.damage_taken >= 9
          robot.destroyed = true
          @board[robot.y][robot.x].delete(robot)
        end
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
  
  def add_parallel_robot_action(robot, x, y, direction)
    @parallel_action_queue << {:robot => robot, :x => x, :y => y, :direction => direction }
    @parallel_action_queue.last
  end
  
  def add_sequential_robot_action(robot, priority, distance)
    @sequential_action_queue << {:robot => robot, :priority => priority, :distance => distance }
    @sequential_action_queue.last
  end
  
  def move_robot(robot, distance)       
    direction = robot.direction
    
    if distance < 0 then 
      direction = $mirror_direction[direction] 
    end
    distance = distance.abs  
    
    new_coord = {:x => robot.x, :y => robot.y}
    distance.times do
      new_coord = offset_coordinate(new_coord[:x], new_coord[:y], direction)
      # even if this is an edge or a pit, we can push on it even if the current robot will die there, anything else reached this new_coord is already dead
      self.push(new_coord[:x], new_coord[:y], direction)
      update_robot(robot, new_coord[:x], new_coord[:y], robot.direction)
      break if robot.destroyed
    end  
  end  
    
  def shoot_laser(x, y, direction, options=nil) 
    new_coord = {:x => x, :y => y}    
    target = nil
    
    if options == :exclude_first
      new_coord = offset_coordinate(new_coord[:x], new_coord[:y], direction)
    end
    
    begin      
      break if new_coord[:x] < 0 or new_coord[:y] < 0 or new_coord[:y] >= @board.length or new_coord[:x] >= @board[new_coord[:y]].length             
      
      target = get_typed_at(new_coord[:x], new_coord[:y], Robot).first
      
      new_coord = offset_coordinate(new_coord[:x], new_coord[:y], direction)
    end while target.nil?
    
    if target then
      target.damage_taken = target.damage_taken + 1
    end
  end  
  
  def push(x, y, direction)
    pushed_robot = self.get_typed_at(x, y, Robot).first      
    if not pushed_robot.nil? then
      pushed_coord = offset_coordinate(x, y, direction)
      self.push(pushed_coord[:x], pushed_coord[:y], direction)      
      update_robot(pushed_robot, pushed_coord[:x], pushed_coord[:y], pushed_robot.direction)
    end    
  end
  
  def update_robot(robot, x, y, direction)          
    @board[robot.y][robot.x].delete(robot)
    
    # driving of the edge destroys    
    if x < 0 or y < 0 or y >= @board.length or x >= @board[y].length 
      robot.destroyed = true
      return
    end         
    
    # driving in a pit destroys
    pit = self.get_typed_at(x, y, Pit).first
    if not pit.nil? 
      robot.destroyed = true
      return      
    end
                            
    robot.x = x
    robot.y = y
    robot.direction = direction
    
    @board[y][x] << robot
  end
  
  def get_robot(id)
    @robots[id]
  end
  
  def get_typed_at(x, y, type)    
    return [] if x < 0 or y < 0 or y >= @board.length or x >= @board[y].length 
        
    return @board[y][x].find_all{|item| item.instance_of? type}      
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