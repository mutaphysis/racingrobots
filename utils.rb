$key_direction = {"w" => :west, "n" => :north, "e" => :east, "s" => :south }
$key_rotation  = {"l" => :left, "r" => :right }
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
