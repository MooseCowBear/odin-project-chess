module SquareChecker
  def checks_for_square(board: square:, opponent_neighbors:, color:) # both checks full stop, but also king moves and castling
    checks = knight_checks(square: square, color: color)
    opponent_neighbors.each do |opponent|
      if board.under_attack?(from: opponent, to: square, color: color)
        checks << opponent
      end
    end
    checks 
  end

  private 
  
  def knight_checks(square:, color:)
    offsets = [[1, 2], [2, 1], [-1, 2], [2, -1], [1, -2], [-2, 1], [-1, -2], [-2, -1]] # update after updating knight
    knight_checks = []
    offsets.each do |offset|
      row, col = square[0] + offset[0], square[1] + offset[1]
      if board.under_attack?(from: [row, col], to: square, color: color)
        knight_checks << board.get_piece([row, col])
      end
    end
    knight_checks
  end
end