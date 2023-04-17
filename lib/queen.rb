require_relative './euclid.rb'
require_relative './path_checker.rb'
require_relative './board_check.rb'

require 'set'

class Queen
  include Euclid
  include PathChecker 
  include BoardCheck

  attr_reader :slopes, :color

  def initialize(color = "white")
    @slopes = Set.new([nil, 1.0, 0.0, -1.0]) 
    @color = color
  end

  def to_s 
    color == "white" ? "\u{2655}" : "\u{265B}"
  end

  def get_start_position
    color == "black" ? [0, 3] : [7, 3]
  end

  def moves(board, start_idx)
    moves = { start_idx => [] }
    offsets = [ [0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1] ]
    offsets.each do |o|
      m = start_idx[0] + o[0]
      n = start_idx[1] + o[1]
      while on_board?([m, n])
        if valid_move?(board, start_idx, [m, n])
          moves[start_idx] << [m, n] 
          m += o[0]
          n += o[1]
        else 
          break
        end
      end
    end
    moves
  end


  def valid_move?(board, start_idx, end_idx)
    slope = slope(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    path_clear = slope.nil? ? clear_vertical_path?(color, board, start_idx, end_idx) : clear_non_vertical_path?(color, board, start_idx, end_idx, slope)
    slopes.include?(slope) && path_clear
  end
end