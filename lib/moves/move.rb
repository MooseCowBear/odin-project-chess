class Move
  attr_reader :piece, :from, :to

  def initialize(from:, to:, piece:, captures: nil)
    @from = from
    @to = to
    @piece = piece
    @captures = captures # the piece -- do you want this? compueter could use it
  end

  def promote?
    piece.promotable && piece.last_row == to[0]
  end

  def execute(board)
    board.update(position: from, value: nil)
    board.update(position: to, value: piece)
    piece.position = to #update the piece to its new position
  end
end