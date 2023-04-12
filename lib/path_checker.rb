module PathChecker
  def clear_non_vertical_path?(board, start_idx, end_idx, slope)
    start_idx, end_idx = order_non_vert(start_idx, end_idx)

    y1, x1 = start_idx
    y2, x2 = end_idx

    (x1 + 1).upto(x2 - 1) do |interm_x|
      interm_y = slope * (interm_x - x1) + y1 
      return false unless board[interm_y][interm_x].nil?
    end
    true
  end

  def clear_vertical_path?(board, start_idx, end_idx)
    #only works in one direction !
    start_idx, end_idx = order_vert(start_idx, end_idx)

    y1, x1 = start_idx
    y2, x2 = end_idx

    (y1 + 1).upto(y2 - 1) do |interm_y|
      return false unless board[interm_y][x1].nil?
    end
    true
  end

  def order_non_vert(start_idx, end_idx)
    #x1 needs to be smaller than x2 for nonvert
    return [end_idx, start_idx] if end_idx[1] < start_idx[1]
    [start_idx, end_idx]
  end

  def order_vert(start_idx, end_idx)
    #y1 needs to be smaller than y2
    return [end_idx, start_idx] if end_idx[0] < start_idx[0]
    [start_idx, end_idx]
  end
end