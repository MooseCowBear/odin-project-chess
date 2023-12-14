module Slope
  def slope(from, to) 
    row1, col1 = from 
    row2, col2 = to 
    return nil if (col2.to_f - col1.to_f) == 0
    return (row2.to_f - row1.to_f) / (col2.to_f - col1.to_f)
  end
end