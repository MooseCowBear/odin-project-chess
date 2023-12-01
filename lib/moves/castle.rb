require_relative "./move.rb"

class Castle < Move
  attr_reader :additional_from, :additional_to, :rook

  def initialize(from:, to:, piece:, additional_from:, additional_to:, rook:, captures: nil)
    super(from: from, to: to, piece: piece, captures: captures)
    @additional_from = additional_from
    @additional_to = additional_to
    @rook = rook
  end

  def execute(board)
    super
    board.update(position: additional_to, value: rook)
    board.update(position: additional_from, value: nil)
  end
end