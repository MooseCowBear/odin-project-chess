require_relative './euclid.rb'
require_relative './path_checker.rb'

class Knight
  include Euclid
  include PathChecker

  attr_reader :slopes
  
  def initialize
    @slopes = Set.new([2.0, 0.5])
  end

  def valid_move?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false if slope.nil?
    return false unless slopes.include?(slope.abs)
    true
  end
end