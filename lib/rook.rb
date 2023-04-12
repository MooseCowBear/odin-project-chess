require_relative './euclid.rb'
require_relative './path_checker.rb'

class Rook
  include Euclid
  include PathChecker

  attr_reader :slopes
  
  def initialize
    @slopes = Set.new([0.0, nil])
  end

  def valid_move?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false unless slopes.include?(slope) || slopes.include?(slope.abs)

    path_clear = slope.nil? ? clear_vertical_path?(board, start_idx, end_idx) : clear_non_vertical_path?(board, start_idx, end_idx, slope)
    return false unless path_clear

    true
  end
end