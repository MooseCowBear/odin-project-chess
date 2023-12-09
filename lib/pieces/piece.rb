require_relative "../moves/move.rb"

class Piece 
  attr_reader :color, :promotable
  attr_accessor :moved, :position

  def initialize(color:, position:, promotable:)
    @color = color
    @moved = false # need to pawn, king, castle. don't care otherwise really.
    @promotable = promotable # pawn needs to make this true
    @position = position
  end

  def valid_moves(from:, board:)
    # everyone needs a method to produce a list of valid moves
    raise Exception.new "This method needs to be defined in the subclass"
  end

  def valid_move?(to:, from:, board:)
    # everyone needs a method to check if they can move to a square
    raise Exception.new "This method needs to be defined in the subclass"
  end

  # want to be able to compare to player or another piece...Player needs to have a color?
  def teammate?(other) 
    color == other&.color
  end

  def opponent?(other)
    color != other&.color
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