require_relative './euclid.rb'
require_relative './path_checker.rb'
require_relative './board_boundry.rb'

class Queen
  include Euclid
  include PathChecker 
  include BoardBoundry

  attr_reader :slopes

  def initialize
    @slopes = Set.new([nil, 1.0, 0.0]) #will check abs of slope
  end

  def valid_move?(board, start_idx, end_idx)
    correct_move?(board, start_idx, end_idx) && on_board?(board, end_idx)
  end

  private

  def correct_move?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false unless slopes.include?(slope) || slopes.include?(slope.abs)

    path_clear = slope.nil? ? clear_vertical_path?(board, start_idx, end_idx) : clear_non_vertical_path?(board, start_idx, end_idx, slope)
    return false unless path_clear

    true
  end
end