module Euclid
  def slope(x1, y1, x2, y2) #assume board is oriented normal coordinate way, x is col, y is row
    return nil if (x2.to_f - x1.to_f) == 0
    return (y2.to_f - y1.to_f) / (x2.to_f - x1.to_f)
  end

  def distance(x1, y1, x2, y2)
    Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
  end

  #methods to find point of intersection between two lines
  def intersection(x1, y1, slope1, x2, y2, slope2)
    #if no intersection, will return nil. else returns point of intersection as [y, x] bc we want it in that form
    return nil if slope1 == slope2
    if slope1.nil? 
      return find_intersection_vertical(x2, y2, slope2, x1)
    elsif slope2.nil?
      return find_intersection_vertical(x1, y1, slope1, x2)
    else
      return find_intersection_non_vertical(x1, y1, slope1, x2, y2, slope2)
    end
  end

  def find_intersection_vertical(non_vert_x, non_vert_y, non_vert_slope, vert_x)
    x = vert_x
    y = non_vert_y + non_vert_slope * (vert_x - non_vert_x)
    [y, x] 
  end

  def find_intersection_non_vertical(x1, y1, slope1, x2, y2, slope2)
    x = (slope1 * x1 - slope2 * x2 + y2 - y1) / (slope1 - slope2)
    y = y1 + slope1 * ((slope1 * x1 - slope2 * x2 + y2 - y1) / (slope1 - slope2)) - slope1 * x1
    [y, x] 
  end
end