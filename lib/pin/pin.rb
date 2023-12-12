class Pin
  attr_reader :piece, :attacker

  def initialize(piece:, attacker:)
    @piece = piece
    @attacker = attacker
  end

  def valid_move?(to:, from:, board:)
    piece.valid_move?(to:, from:, board:)
  end

  def position
    piece.position
  end
end