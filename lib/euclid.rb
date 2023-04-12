module Euclid
  def slope(x1, y1, x2, y2) #assume board is oriented normal coordinate way, x is col, y is row
    return nil if (x2.to_f - x1.to_f) == 0
    return (y2.to_f - y1.to_f) / (x2.to_f - x1.to_f)
  end

  def distance(x1, y1, x2, y2)
    Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
  end
end