class Pin
  attr_reader :piece, :attacker

  def initialize(piece:, attacker:)
    @piece = piece
    @attacker = attacker
  end
end