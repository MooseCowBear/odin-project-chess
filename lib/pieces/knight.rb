require_relative "./piece.rb"

class Knight < Piece
  attr_reader :offsets

  def initialize(color:, position:, promotable: false)
    super
    @offsets = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1]]
  end

  def to_s 
    white? ? "\u{2658}" : "\u{265E}"
  end

  def valid_move?(from:, to:, board:) # same as king
    offsets.include?([to[0] - from[0], to[1] - from[1]]) && !teammate?(board.get_piece(to)) 
  end

  def valid_moves(from:, board:) # same as king
    moves = []
    offsets.each do |offset| 
      to = [from[0] + offset[0], from[1] + offset[1]]
      if board.on_board?(to) && valid_move?(from: from, to: to, board: board)
        moves << Move.new(from: from, to: to, piece: self, captures: board.get_piece(to))
      end
    end
    moves
  end
end