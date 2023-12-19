class MoveConverter
  def convert(input, moves)
    return nil if input.length != 4
    moves.select { |move| move.from == start_idx(input) && move.to == end_idx(input) }.first 
  end

  def start_idx(input)
    [convert_row(input[1]), convert_column(input[0])]
  end

  def end_idx(input)
    [convert_row(input[3]), convert_column(input[2])]
  end

  def convert_column(char)
    char.downcase.ord - 97
  end

  def convert_row(char)
    8 - char.to_i
  end
end