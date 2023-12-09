module SquareChecker
  # TODO: rename "king" param to allied_with ?? (more accurate)
  def checks_for_square(board:, square:, opponent_neighbors:, king:) # both checks full stop, but also king moves and castling
    checks = knight_checks(square: square, king: king)
    opponent_neighbors.each do |opponent|
      if board.under_attack?(from: opponent, to: square, piece: king)
        checks << opponent
      end
    end
    checks 
  end

  private 
  
  def knight_checks(square:, king:)
    offsets = [[1, 2], [2, 1], [-1, 2], [2, -1], [1, -2], [-2, 1], [-1, -2], [-2, -1]] # update after updating knight
    knight_checks = []
    offsets.each do |offset|
      row, col = square[0] + offset[0], square[1] + offset[1]
      if board.under_attack?(from: [row, col], to: square, piece: king)
        knight_checks << board.get_piece([row, col])
      end
    end
    knight_checks
  end
end