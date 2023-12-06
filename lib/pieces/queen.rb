require_relative '../euclid.rb'
require_relative "./piece.rb"

class Queen < Piece
  include Euclid # want slope
  attr_reader :offsets, :slopes

  def initialize(color:, position:, promotable: false)
    super 
    @offsets = [[-1, 0], [1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    @slopes = [nil, 1.0, 0.0, -1.0]
  end

  def to_s 
    color == "white" ? "\u{2655}" : "\u{265B}"
  end

  def initial_position # maybe don't need this
    white? ? [7, 3] : [0, 3]
  end

  def valid_move?(from:, to:, board:)
    # does not check for intermediary squares being taken because always walking outward
    slopes.include?(slope(from, to)) && !teammate?(board.get_piece(to)&.color)
  end

  def valid_moves(from:, board:)
    moves = []

    offsets.each do |offset|
      to = [from[0] + offset[0], from[1] + offset[1]]

      while board.on_board?(to)
        if valid_move?(from: from, to: to, board: board)
          moves << Move.new(from: from, to: to, piece: self, captures: board.get_piece(to))
          to = [to[0] + offset[0], to[1] + offset[1]]
          break if opponent?(board.get_piece(to)&.color) # hit opponent
        else
          break # hit a teammate or end of board
        end
      end
    end
    moves
  end
end