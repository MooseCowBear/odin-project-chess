require_relative './euclid.rb'
require_relative './path_checker.rb'
require_relative './board_check.rb'

require 'set'

class Bishop
  include Euclid
  include PathChecker
  include BoardCheck

  attr_reader :slopes, :color, :num

  def initialize(num = 1, color = "white")
    @slopes = Set.new([1.0, -1.0])
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

  def moves(board, start_idx)
    moves = Hash.new { |h, k| h[k] = [] }
    offsets = [ [1, 1], [-1, -1], [1, -1], [-1, 1] ]

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
    
    slopes.include?(slope) && clear_non_vertical_path?(color, board, start_idx, end_idx, slope)
  end
end