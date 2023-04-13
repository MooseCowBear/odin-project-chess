require_relative './euclid.rb'
require_relative './path_checker.rb'

class Queen
  include Euclid
  include PathChecker 

  attr_reader :slopes, :color

  def initialize(color = "white")
    @slopes = Set.new([nil, 1.0, 0.0]) #will check abs of slope
    @color = color
  end

  def to_s 
    color == "white" ? "\u{2655}" : "\u{265B}"
  end

  def get_start_position
    color == "black" ? [0, 3] : [7, 3]
  end

  def valid_move?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false unless slopes.include?(slope) || slopes.include?(slope.abs)

    path_clear = slope.nil? ? clear_vertical_path?(board, start_idx, end_idx) : clear_non_vertical_path?(board, start_idx, end_idx, slope)
    return false unless path_clear

    true
  end
end