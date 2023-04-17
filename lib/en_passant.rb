class EnPassant

  attr_accessor :from, :to, :opponent_pawn_pos, :rescue

  def initialize(from, to, opponent_pawn_pos)
    @from = from
    @to = to
    @opponent_pawn_pos = opponent_pawn_pos
    @rescue = false
  end
end
