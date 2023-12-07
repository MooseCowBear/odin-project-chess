require_relative "./piece.rb"

class Pawn < Piece
  def initialize(color:, position:, promotable: true)
    super 
  end

  def to_s 
    color == "white" ? "\u{2659}" : "\u{265F}"
  end

  def valid_move?(from:, to:, board:) 
    if !board.get_piece(to)
      non_attack_offsets.include?([to[0] - from[0], to[1] - from[1]])
    elsif self.opponent?(board.get_piece(to).color)
      attack_offsets.include?([to[0] - from[0], to[1] - from[1]])
    else
      false # teammate
    end
  end

  def valid_moves(from:, board:)
    moves = []

    attack_offsets.each do |offset|
      to = [from[0] + offset[0], from[1] + offset[1]]
      if board.on_board?(to) && valid_move?(from: from, to: to, board: board)
        moves << Move.new(from: from, to: to, piece: self, captures: board.get_piece(to)) 
      end
    end

    distance = moved ? 1 : 2
    offset = non_attack_offsets.first

    distance.times do |i|
      to = [from[0] + offset[0] * (i + 1), from[1] + offset[1]]
      if board.on_board?(to) && !board.get_piece(to) # is the square empty
        moves << Move.new(from: from, to: to, piece: self, captures: nil)
      else
        break 
      end
    end
    moves 
  end

  private

  def non_attack_offsets
    if white?
      moved ? [[-1, 0]] : [[-1, 0], [-2, 0]] 
    else
      moved ? [[1, 0]] : [[1, 0], [2, 0]]
    end
  end

  def attack_offsets 
    if white?
      [[-1, -1], [-1, 1]]
    else
      [[1, -1], [1, 1]] 
    end
  end
end