class MoveConverter
  def initialize
  end

  def converted_move(input, moves)
    return nil if input.length != 4
    moves.select { |move| move.from == start_idx(input) && move.to == end_idx(input) }.first # returns nil if empty
  end

  def start_idx(input)
    [convert_row(input[1]), convert_column(input[0])]
  end

  def end_idx(input)
    [convert_row(input[3]), convert_column(input[2])]
  end

  def convert_column(char)
    char.ord - 97
  end

  def convert_row(char)
    8 - char.to_i
  end
end