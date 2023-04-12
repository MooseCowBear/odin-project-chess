module PathChecker
  def clearNonVerticalPath?(board, start_idx, end_idx, slope)
    y1, x1 = start_idx
    y2, x2 = end_idx

    (x1 + 1).upto(x2 - 1) do |interm_x|
      interm_y = slope * (interm_x - x1) + y1 
      return false unless board[interm_y][interm_x].nil?
    end
    true
  end

  def clearVerticalPath?(board, start_idx, end_idx)
    y1, x1 = start_idx
    y2, x2 = end_idx

    (y1 + 1).upto(y2 - 1) do |interm_y|
      return false unless board[interm_y][x1].nil?
    end
    true
  end
end