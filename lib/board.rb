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

  def under_attack?(from:, to:, color:) 
    !!(on_board?(from) && 
      get_piece(from)&.opponent?(color) && 
      get_piece(from)&.valid_move?(from: from, to: to, board: self)) 
  end
end