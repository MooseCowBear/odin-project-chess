require_relative './euclid.rb'
require_relative './path_checker.rb'
require_relative './board_check.rb'

require 'set'

class Knight
  include Euclid
  include PathChecker
  include BoardCheck

  attr_reader :slopes, :distances, :color, :num
  
  def initialize(num = 1, color = "white")
    @slopes = Set.new([2.0, -2.0, 0.5, -0.5])
    @distances = Set.new([Math.sqrt(5)])
    @color = color
    @num = num
  end

  def to_s 
    color == "white" ? "\u{2658}" : "\u{265E}"
  end

  def get_start_position
    if num == 1
      color == "black" ? [0, 1] : [7, 1]
    else
      color == "black" ? [0, 6] : [7, 6]
    end
  end

  def moves(board, start_idx)
    moves = { start_idx => [] }
    offsets = [ [1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1] ]
    offsets.each do |o|
      m = start_idx[0] + o[0]
      n = start_idx[1] + o[1]
      moves[start_idx] << [m, n] if on_board?([m, n])
    end
    moves
  end

  def valid_move?(board, start_idx, end_idx)
    correct_slope?(board, start_idx, end_idx) && correct_distance?(start_idx, end_idx)
  end

  private 

  def correct_slope?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false unless slopes.include?(slope)
    true
  end

  def correct_distance?(start_idx, end_idx)
    dist = distance(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false unless distances.include?(dist)
    true
  end
end