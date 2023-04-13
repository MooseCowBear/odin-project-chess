require_relative './euclid.rb'
require_relative './path_checker.rb'

class Bishop
  include Euclid
  include PathChecker

  attr_reader :slopes, :color, :num

  def initialize(num = 1, color = "white")
    @slopes = Set.new([1.0])
    @color = color
    @num = num
  end

  def to_s 
    color == "white" ? "\u{2657}" : "\u{265D}"
  end

  def get_start_position
    if num == 1
      color == "black" ? [0, 2] : [7, 2]
    else
      color == "black" ? [0, 5] : [7, 5]
    end
  end

  def valid_move?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false if slope.nil?
    return false unless slopes.include?(slope.abs)
    return false unless clear_non_vertical_path?(board, start_idx, end_idx, slope)
    true
  end
end