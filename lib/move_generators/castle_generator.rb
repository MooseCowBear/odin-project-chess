require_relative "../modules/square_checker.rb"
require_relative "../moves/castle.rb"

class CastleGenerator
  include SquareChecker 

  attr_reader :board, :king

  def initialize(king, board)
    @king = king
    @board = board
  end

  def castles
    return [] if king.moved
    [queenside, kingside].compact
  end 

  def queenside
    rook = queenside_rook
    if castleable?(rook, -2)
      Castle.new(
        from: king.position, 
        to: [king.position[0], king.position[1] - 2], 
        piece: king,
        additional_from: rook.position, 
        additional_to: [rook.position[0], rook.position[1] + 3],
        rook: rook
      )
    end
  end

  def kingside
    rook = kingside_rook
    if castleable?(rook, 2)
      Castle.new(
        from: king.position, 
        to: [king.position[0], king.position[1] + 2], 
        piece: king,
        additional_from: rook.position, 
        additional_to: [rook.position[0], rook.position[1] - 2],
        rook: rook
      )
    end
  end

  def castleable?(rook, direction)
    !!rook && !rook.moved && clear_and_safe_passage?(rook, direction)
  end

  def queenside_rook
    king.white? ? board.get_piece([7, 0]) : board.get_piece([0, 0])
  end

  def kingside_rook
    king.white? ? board.get_piece([7, 7]) : board.get_piece([0, 7])
  end

  def clear_and_safe_passage?(rook, direction)
    (clear_passage?(king.position[0], king.position[1], rook.position[1]) &&
      safe_passage?(king.position[0], king.position[1], king.position[1] + direction))
  end

  def clear_passage?(row, min, max)
    if min > max
      min, max = max, min
    end

    (min + 1).upto(max - 1) do |col|
      return false if board.get_piece([row, col])
    end
    true
  end

  def safe_passage?(row, min, max) 
    if min > max
      min, max = max, min
    end

    min.upto(max) do |col| 
      unless unchecked_square?(square: [row, col], board: board, alliance: king) 
        return false
      end
    end
    true
  end
end