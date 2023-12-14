require_relative "../modules/slope.rb"
require_relative "./piece.rb"

class Bishop < Piece
  include Slope

  @@offsets = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  @@slopes = [1.0, -1.0]

  def initialize(color:, position:, promotable: false)
    super
  end

  def to_s 
    white? ? "\u{2657}" : "\u{265D}"
  end

  def valid_move?(from:, to:, board:) # exact same as queen...
    @@slopes.include?(slope(from, to)) && !teammate?(board.get_piece(to))
  end

  def valid_moves(from:, board:) # exact same as queen...
    moves = []

    @@offsets.each do |offset|
      to = [from[0] + offset[0], from[1] + offset[1]]

      while board.on_board?(to)
        if valid_move?(from: from, to: to, board: board)
          moves << Move.new(from: from, to: to, piece: self, captures: board.get_piece(to))
          to = [to[0] + offset[0], to[1] + offset[1]]
          break if opponent?(board.get_piece(to)) # hit opponent
        else
          break # hit a teammate or end of board
        end
      end
    end
    moves
  end
end