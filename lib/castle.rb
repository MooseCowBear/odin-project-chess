class Castle

  attr_reader :king_start, :king_end, :rook_start, :rook_end

  def initialize(king_start, king_end, rook_start, rook_end)
    @king_start = king_start
    @king_end = king_end
    @rook_start = rook_start
    @rook_end = rook_end
  end
end