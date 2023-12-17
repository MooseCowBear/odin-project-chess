class Move
  attr_reader :piece, :from, :to

  def initialize(from:, to:, piece:, captures:)
    @from = from
    @to = to
    @piece = piece
    @captures = captures
  end

  def promote?
    piece.promotable && piece.last_row == to[0]
  end

  def execute(board)
    board.update(position: from, value: nil)
    board.update(position: to, value: piece)
    piece.position = to #update the piece to its new position
    piece.moved = true 
  end

  def check_enpassant?
    piece.promotable? && (from[0] - to[0]).abs == 2
  end

  def to_s
    "from #{convert(from)} to #{convert(to)}"
  end

  private 

  def convert(position)
    letter = (position[1] + 97).chr
    num = 8 - position[0]

    "#{letter}#{num}"
  end
end