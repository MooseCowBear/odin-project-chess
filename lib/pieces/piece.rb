class Piece 
  attr_reader :color 
  attr_accessor :moved

  def initialize(color:, position:, promotable: false)
    @color = color
    @moved = false # need to pawn, king, castle. don't care otherwise really.
    @promotable = promotable # pawn needs to make this true
    @position = position
  end

  def valid_moves(from:)
    # everyone needs a method to produce a list of valid moves
    raise Exception.new "This method needs to be defined in the subclass"
  end

  def valid_move?(to:, from:)
    # everyone needs a method to check if they can move to a square
    raise Exception.new "This method needs to be defined in the subclass"
  end

  def teammate?(player_color) # do you want opponent too?
    color == player_color
  end

  def opponent?(player_color)
    color != player_color
  end

  def to_s
    raise Exception.new "This method needs to be defined in the subclass"
  end

  def white?
    color == "white"
  end

  def last_row 
    white? ? 0 : 7
  end
end