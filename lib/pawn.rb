require_relative './euclid.rb'
require_relative './path_checker.rb'

class Pawn
  include Euclid
  include PathChecker

  attr_reader :color, :num
  attr_accessor :moved

  def initialize(num = 1, color = "white")
    @slopes = Set.new([nil]) #using for intercepting moves
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
    #note: en passant move is checked in chess class
    taking_opponent_piece = capturing?(board, end_idx)
    if taking_opponent_piece
      (correct_distance?(start_idx, end_idx, taking_opponent_piece) && 
      correct_direction?(start_idx, end_idx))
    else
      (correct_distance?(start_idx, end_idx, taking_opponent_piece) && 
      correct_direction?(start_idx, end_idx) && 
      clear_vertical_path?(board, start_idx, end_idx, true))
    end
  end

  private

  def correct_distance?(start_idx, end_idx, capture)
    dist = distance(start_idx[1], start_idx[0], end_idx[1], end_idx[0])
    return true if !capture && (dist == 1.0 || (dist == 2.0 && !moved))
    return true if capture && dist == Math.sqrt(2)
    false
  end

  def capturing?(board, end_idx)
    #just checking if they are attempting to capture. capturing on the diagonal gets tested in correct distance
    return false if board[end_idx[0]][end_idx[1]].nil? || board[end_idx[0]][end_idx[1]].color == self.color
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