module Euclid
  def slope(x1, y1, x2, y2)
    begin 
      return (y2 - y1) / (x2 - x1)
    rescue ZeroDivisionError
      return nil
    end
  end

  def distance(x1, y1, x2, y2)
    Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
  end
end