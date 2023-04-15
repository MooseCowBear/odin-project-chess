require_relative './euclid.rb'
require_relative './path_checker.rb'

require 'set'

class Rook
  include Euclid
  include PathChecker

  attr_reader :slopes, :color, :num
  attr_accessor :moved
  
  def initialize(num = 1, color = "white")
    @slopes = Set.new([0.0, nil])
    @color = color
    @num = num
    @moved = false
  end

  def to_s 
    color == "white" ? "\u{2656}" : "\u{265C}"
  end

  def get_start_position
    if num == 1
      color == "black" ? [0, 0] : [7, 0]
    else
      color == "black" ? [0, 7] : [7, 7]
    end
  end

  def valid_move?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    path_clear = slope.nil? ? clear_vertical_path?(board, start_idx, end_idx) : clear_non_vertical_path?(board, start_idx, end_idx, slope)

    return false unless slopes.include?(slope) && path_clear 
    true
  end
end