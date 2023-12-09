require_relative "./move.rb"

class EnPassant < Move
  attr_reader :additional_from

  def initialize(from:, to:, piece:, additional_from:, captures:)
    super(from: from, to: to, piece: piece, captures: captures)
    @additional_from = additional_from
  end

  def execute(board)
    super
    board.update(position: additional_from, value: nil)
  end
end