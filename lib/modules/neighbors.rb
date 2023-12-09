module Neighbors 
  def closest_neighbors(board:, square:, piece:) #color is color of piece on square, hypothetical or not
    opponents = []
    teammates = []
    directions = [[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]]

    directions.each do |dir|
      closest_neighbor = closest_neighbor_in_direction(square: square, direction: dir)
      if board.get_piece(position: closest_neighbor)&.opponent?(piece)
        opponents << closest_neighbor
      elsif board.get_piece(position: closest_neighbor)
        teammates << closest_neighbor
      end
    end
    [opponents, teammates]
  end

  def closest_neighbor_in_direction(board:, square:, direction:)
    row, col = square[0] + direction[0], square[1] + direction[1]
    while baord.on_board?(row, col)
      if board.get_piece([row, col])
        return [row, col]
      end
      row = row + direction[0]
      col = col + direction[1]
    end
    [row, col] # wouldn't be on board, so would fail the under attack check
  end
end