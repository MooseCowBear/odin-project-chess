class Board
  attr_accessor :data

  def initialize
    @data = Array.new(8) { Array.new(8) }
  end

  def get_piece(position)
    @data[position[0]][position[1]]
  end

  def update(position:, value:)
    row, col = position[0], position[1]
    @data[row][col] = value
  end

  def on_board?(position)
    position[0].between?(0, 7) && position[1].between?(0, 7)
  end

  def under_attack?(from:, to:, piece:) 
    !!(on_board?(from) && 
      get_piece(from)&.opponent?(piece) && 
      get_piece(from)&.valid_move?(from: from, to: to, board: self)) 
  end

  def column_neighbors(move:)
    [column_neighbor(move: move, direction: 1), column_neighbor(move: move, direction: -1)].compact
  end

  def column_neighbor(move:, direction:)
    if on_board?([move.to[0], move.to[1] + direction]) 
      get_piece([move.to[0], move.to[1] + direction])
    else 
      nil
    end
  end
end