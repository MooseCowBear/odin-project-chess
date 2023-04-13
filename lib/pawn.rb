require_relative './euclid.rb'
require_relative './path_checker.rb'

class Pawn
  include Euclid
  include PathChecker

  attr_reader :color, :num
  attr_accessor :moved

  def initialize(num = 1, color = "white")
    @moved = false
    @color = color
    @num = num
  end

  def to_s 
    color == "white" ? "u\{2659}" : "u\{265F}"
  end

  def get_start_position
    case num
    when 1
      color == "black" ? [1, 0] : [6, 0]
    when 2
      color == "black" ? [1, 1] : [6, 1]
    when 3
      color == "black" ? [1, 2] : [6, 2]
    when 4
      color == "black" ? [1, 3] : [6, 3]
    when 5
      color == "black" ? [1, 4] : [6, 4]
    when 6
      color == "black" ? [1, 5] : [6, 5]
    when 7
      color == "black" ? [1, 6] : [6, 6]
    else
      color == "black" ? [1, 7] : [6, 7]
    end
  end

  def valid_move?(board, start_idx, end_idx)
    #moves are 1. generally vertical (direction depends on color)
    #can be kitty corner when taking opponent piece (if there is one to take)
    #or if en passant - gets checked in the game itself
    taking_opponent_piece = taking?(board, end_idx)
    correct_distance?(start_idx, end_idx, taking_opponent_piece) && correct_direction?(start_idx, end_idx)
  end

  private

  def correct_distance?(start_idx, end_idx, taking)
    dist = distance(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return false unless !taking && (dist == 1.0 || (dist == 2.0 && !moved))
    return false unless taking && dist == Math.sqrt(2)
    true
  end

  def taking?(board, end_idx)
    return false if board[end_idx[0]][end_idx[1]].nil?
    true
  end

  def correct_direction?(start_idx, end_idx)
    if color == "white" && end_idx[0] < start_idx[0]
      return true
    elsif color == "black" && end_idx[0] > start_idx[0]
      return true
    end
    false
  end
end