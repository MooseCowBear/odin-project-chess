require_relative "../modules/slope.rb"
require_relative "./piece"

class Rook < Piece
  include Slope

  @@offsets = [[0, 1], [0, -1], [1, 0], [-1, 0]]
  @@slopes = [0.0, nil]

  def initialize(color:, position:, promotable: false)
    super
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
          break if opponent?(board.get_piece(to)) 
        else
          break 
        end
      end
    end
    moves
  end
end