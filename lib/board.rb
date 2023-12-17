class Board
  attr_accessor :data

  @@directions = [[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]]

  def initialize
    @data = Array.new(8) { Array.new(8) }
  end

  def get_piece(position)
    data[position[0]][position[1]]
  end

  def update(position:, value:)
    row, col = position[0], position[1]
    @data[row][col] = value
  end

  def on_board?(position)
    position[0].between?(0, 7) && position[1].between?(0, 7)
  end

  def under_attack?(from:, to:, alliance:) 
    !!(on_board?(from) && 
      get_piece(from)&.opponent?(alliance) && 
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

  def closest_neighbors(square:, alliance:) 
    opponents = []
    teammates = []

    @@directions.each do |dir|
      closest_neighbor = closest_neighbor_in_direction(square: square, direction: dir)
      if !on_board?(closest_neighbor)
        next
      elsif get_piece(closest_neighbor)&.opponent?(alliance)
        opponents << closest_neighbor
      elsif get_piece(closest_neighbor)
        teammates << closest_neighbor
      end
    end
    [opponents, teammates]
  end

  def closest_neighbor_in_direction(square:, direction:)
    row, col = square[0] + direction[0], square[1] + direction[1]
    while on_board?([row, col])
      if get_piece([row, col])
        return [row, col]
      end
      row = row + direction[0]
      col = col + direction[1]
    end
    [row, col]
  end

  def directions
    @@directions
  end

  def print 
    puts "    a   b   c   d   e   f   g   h  "
    puts "   ___ ___ ___ ___ ___ ___ ___ ___ "
  
    row_label = 8
    8.times do |row_idx|
      line = "#{row_label} |"

      board[row_idx].each do |elem|
        line +=  "#{elem.to_s}"
        line += elem ? " |" : "  |"
      end
      puts line
      puts "   ___ ___ ___ ___ ___ ___ ___ ___ "
      
      row_label -= 1
    end
  end
end