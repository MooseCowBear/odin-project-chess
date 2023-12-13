require_relative "../modules/square_checker.rb"
require_relative "../modules/euclid.rb"
require_relative "./castle_generator.rb"

class MoveGenerator
  include SquareChecker
  include Euclid

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
      MoveGenerator
    when 1
      SingleCheckMoveGenerator
    else
      MultiCheckMoveGenerator
    end.new(king, board, checks, last_move) 
  end

  def moves
     king_moves + get_enpassant + non_king_moves + CastleGenerator.new(king, board).castles
  end

  def king_moves
    king.valid_moves.filter { |move| unchecked_square?(square: move.to, board: board, alliance: king) }
  end

  def get_enpassant
    @enpassant = []
    if last_move.check_enpassant?
      neighbors = board.column_neighbors(move: last_move).filter do |n|
        n.opponent?(last_move.piece) && n.promotable? 
      end
      neighbors.each do |neighbor| 
        to = [last_move.to[0] + neighbor.direction, last_move.to[1]] 
        @enpassant << EnPassant.new(from: neighbor.position, to: to, piece: neighbor, additional_from: last_move.to, captures: last_move.piece)
      end
    end
    @enpassant
  end

  def non_king_moves
    moves = []
    pins = PinFinder.new(board, king).get_pins
    8.times do |row|
      8.times do |col|
        moves << piece_moves(board.get_piece([row, col]), pins)
      end
    end
    moves
  end

  def piece_moves(piece, pins) 
    index = pins.index { |p| p.piece == piece }
    if index 
      pin_moves(pins[index].piece)
    elsif piece && piece != king # not ideal
      piece.valid_moves(from: piece.position, board: board) 
    else
      []
    end
  end

  def pin_moves(pin)
    moves = []
    squares_in_range(pin.attacker).each do |square|
      if square == pin.position
        next
      elsif pin.valid_move?(to: square, from: pin.position, board: board)
        moves << Move.new(to: square, from: pin.position, piece: pin.piece, captures: board.get_piece(square))
      elsif enpassant.any? { |ep| ep.piece == pin.piece && ep.to == square } 
        moves << enpassant.select { |ep| ep.piece && ep.to == square }.first
      end
    end 
    moves
  end

  def squares_in_range(opponent) 
    squares = []
    slope = slope(king.position, opponent.position) 

    row, col = king.position 

    if slope.nil?
      dir = king.position[0] < opponent.position[0] ? 1 : -1
      until row == opponent.position[0]
        row += dir
        squares << [row, col]
      end
    else
      dir = king.position[1] < opponent.position[1] ? 1 : -1
      until col == opponent.position[1]
        col += dir
        row += slope * dir
        squares << [row.to_i, col.to_i]
      end
    end
    squares 
  end 
end

class MultiCheckMoveGenerator < MoveGenerator
end

class SingleCheckMoveGenerator < MoveGenerator
end