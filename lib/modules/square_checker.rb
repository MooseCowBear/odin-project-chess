require_relative "../pieces/knight.rb"

module SquareChecker
  def checks_for_square(board:, square:, opponents:, alliance:) 
    knight_checks(square: square, board: board, alliance: alliance)
      .concat(non_knight_checks(square: square, board: board, opponents:  opponents, alliance: alliance))
  end

  def unchecked_square?(square:, board:, alliance:)
    opponents, _ = board.closest_neighbors(square: square, alliance: alliance)
    checks_for_square(board: board, square: square, opponents: opponents, alliance: alliance).empty?
  end

  def non_knight_checks(square:, board:, opponents:, alliance:)
    checks = []
    opponents.each do |opponent|
      if board.under_attack?(from: opponent.position, to: square, alliance: alliance)
        checks << opponent
      end
    end
    checks
  end
  
  def knight_checks(square:, board:, alliance:)
    checks = []
    Knight.offsets.each do |offset|
      row, col = square[0] + offset[0], square[1] + offset[1]
      if board.under_attack?(from: [row, col], to: square, alliance: alliance)
        checks << board.get_piece([row, col])
      end
    end
    checks
  end
end