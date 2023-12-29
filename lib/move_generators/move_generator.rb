require_relative "../modules/square_checker.rb"

class MoveGenerator
  include SquareChecker

  attr_reader :king, :board, :checks, :last_move
  attr_accessor :enpassant

  def initialize(king, board, checks, last_move)
    @king = king
    @board = board
    @checks = checks
    @last_move = last_move
  end

  def self.for(king:, board:, checks:, last_move:) 
    case checks.length
    when 0
      ChecklessMoveGenerator
    when 1
      SingleCheckMoveGenerator
    else
      MultiCheckMoveGenerator
    end.new(king, board, checks, last_move) 
  end

  def moves
     raise Exception.new "This method needs to be defined in the subclass"
  end

  def king_moves
    king.valid_moves.filter { |move| unchecked_square?(square: move.to, board: board, alliance: king) }
  end
end

class MultiCheckMoveGenerator < MoveGenerator
end

class SingleCheckMoveGenerator < MoveGenerator
end

class ChecklessMoveGenerator < MoveGenerator
end