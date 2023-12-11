require_relative "./piece.rb"

class King < Piece
  @@offsets = [[-1, 0], [1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]

  def initialize(color:, position:, promotable: false)
    super
  end

  def to_s
    white? ? "\u{2654}" : "\u{265A}"
  end

  def initial_position # maybe don't need this
    white? ? [7, 4] : [0, 4]
  end

  def valid_move?(from:, to:, board:)
    @@offsets.include?([to[0] - from[0], to[1] - from[1]]) && !teammate?(board.get_piece(to)) 
  end

  def valid_moves(from:, board:) 
    moves = []
    @@offsets.each do |offset| 
      to = [from[0] + offset[0], from[1] + offset[1]]
      if board.on_board?(to) && valid_move?(from: from, to: to, board: board)
        moves << Move.new(from: from, to: to, piece: self, captures: board.get_piece(to))
      end
    end
    moves 
  end
end