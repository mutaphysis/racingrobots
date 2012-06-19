# parse helpers
DIRECTION_SHORT_MAP = {"w" => :west, "n" => :north, "e" => :east, "s" => :south}
ROTATION_SHORT_MAP = {"l" => :left, "r" => :right}

# simple x/y struct
Point = Struct.new(:x, :y)

# turning & mirroring
module Direction
  DIRECTION_MIRROR = {:west => :east, :north => :south, :east => :west, :south => :north}
  DIRECTION_ROTATION = {
      :right => {:west => :north, :north => :east, :east => :south, :south => :west},
      :left => {:west => :south, :south => :east, :east => :north, :north => :west}
  }

  def Direction.mirror(direction)
    DIRECTION_MIRROR[direction]
  end

  def Direction.rotate(direction, rotation_direction)
    DIRECTION_ROTATION[rotation_direction][direction]
  end

  def Direction.rotate_left(direction)
    DIRECTION_ROTATION[:left][direction]
  end

  def Direction.rotate_right(direction)
    DIRECTION_ROTATION[:right][direction]
  end

  def Direction.offset_coordinate(x, y, direction)
    case direction
      when :east
        x += 1
      when :west
        x -= 1
      when :north
        y -= 1
      when :south
        y += 1
      else
    end

    Point.new(x, y)
  end
end