require_relative './euclid.rb'
require_relative './path_checker.rb'

class Knight
  include Euclid
  include PathChecker

  attr_reader :slopes, :distances
  
  def initialize(color = "white")
    @slopes = Set.new([2.0, 0.5])
    @distances = Set.new([Math.sqrt(5)])
    @color = color
  end

  def valid_move?(board, start_idx, end_idx)
    correct_slope?(board, start_idx, end_idx) && correct_distance?(board, start_idx, end_idx)
  end

  private 
  def correct_slope?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false if slope.nil?
    return false unless slopes.include?(slope.abs)
    true
  end

  def correct_distance?(board, start_idx, end_idx)
    dist = distance(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false unless distances.include?(dist)
    true
  end
end