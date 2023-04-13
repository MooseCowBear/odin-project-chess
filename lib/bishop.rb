require_relative './euclid.rb'
require_relative './path_checker.rb'

class Bishop
  include Euclid
  include PathChecker

  attr_reader :slopes, :color

  def initialize(color = "white")
    @slopes = Set.new([1.0])
    @color = color
  end

  def valid_move?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false if slope.nil?
    return false unless slopes.include?(slope.abs)
    return false unless clear_non_vertical_path?(board, start_idx, end_idx, slope)
    true
  end
end