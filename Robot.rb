require_relative 'BoardElement'

class Robot < BoardElement
  attr_reader :id, :saved_at, :lives, :program
  attr_accessor :damage_taken, :cards

  def initialize(x, y, direction, id)
    super(x, y, direction)
    @id = id
    @cards = []
    @program = []
    @waiting_for = []
    @damage_taken = 0
    @lives = 3
    @destroyed = false
    @saved_at = nil

    @phases = [100, 600]
  end

  def act(game, turn, phase)
    return if @destroyed

    case phase
      when 100
        run_program(game, turn)
      when 600
        game.shoot_laser(@x, @y, @direction, :exclude_first)
      else
    end
  end

  def run_program(game, turn)
    card = @program[turn]

    unless card.nil?
      card.act(game, self)
    end
  end

  def choose_program(program)
    allowed_cards = [5, [0, 5 - @damage_taken + 4].max].min

    fail "Wrong number of cards chosen #{program.length} instead of #{allowed_cards}" unless program.length == allowed_cards

    new_program = []
    program.each do |chosen_card|
      unless @cards.include? chosen_card
        # restore cards before failing
        @cards += new_program
        fail "Chosen card not found in cards"
      end
      @cards.delete chosen_card
      new_program << chosen_card
    end
    @program += new_program

    finished_input :choose_program_cards
  end

  def awaited_input
    @waiting_for
  end

  def awaits_input(needed_action)
    @waiting_for << needed_action
  end

  def finished_input(finished_action)
    @waiting_for.delete finished_action
  end

  def waiting?
    !@waiting_for.empty?
  end

  def save(x=nil, y=nil)
    @saved_at = Point.new(x || @x, y || @y)
  end

  def heal(amount)
    @damage_taken = [0, @damage_taken - amount].max
  end

  def destroy
    fail "Robot already destroyed" if @destroyed

    @destroyed = true
    @lives -= 1
  end

  def destroyed?
    @destroyed
  end

  def restore
    fail "Robot has not been saved" if @saved_at.nil?

    # copies are restored with two damage
    @damage_taken = 2
    @destroyed = false
    @x = @saved_at.x
    @y = @saved_at.y
    @direction = :undefined
  end
end
