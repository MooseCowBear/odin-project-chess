require_relative "../moves/move.rb"

class Piece 
  attr_reader :color, :promotable
  attr_accessor :moved, :position

  def initialize(color:, position:, promotable: false)
    @color = color
    @moved = false # need to pawn, king, castle. don't care otherwise really.
    @promotable = promotable # pawn needs to make this true
    @position = position
  end

  def valid_moves(from:, board:)
    # everyone needs a method to produce a list of valid moves
    raise Exception.new "This method needs to be defined in the subclass"
  end

  def valid_move?(to:, from:)
    # everyone needs a method to check if they can move to a square
    raise Exception.new "This method needs to be defined in the subclass"
  end

  # want to be able to compare to player or another piece...
  def teammate?(other_color) 
    color == other_color
  end

  def opponent?(other_color)
    color != other_color
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

  private 

  def add_valid_move(from:, to:, board:, moves:) 
    return unless board.on_board?(to)
    captures = move_captures(to: to, board: board)

    if teammate?(captures.color)
      return
    else
      moves << Move.new(from: from, to: to, piece: self, captures: captures) 
    end
  end

  def move_captures(to:, board:)
    board.get_piece(to)
  end
end