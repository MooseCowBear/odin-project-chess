require_relative './euclid.rb'
require_relative './path_checker.rb'

class King
  include Euclid
  include PathChecker

  attr_reader :distances
  attr_accessor :moved, :position

  def initialize(color = "white")
    @distances = Set.new([1, Math.sqrt(2)])
    @moved = false
    @color = color
    @can_castle = true
    @position = get_start_position(color) #is this ok?
  end

  def to_s 
    color == "white" ? "\u{2654}" : "\u{265A}"
  end

  def get_start_position(color)
    color == "black" ? [0, 4] : [7, 4]
  end

  def valid_move?(board, start_idx, end_idx)
    y1, x1 = start_idx
    y2, x2 = end_idx
    dist = distance(x1, y1, x2, y2)
    return false unless distances.include?(dist)
  end
end