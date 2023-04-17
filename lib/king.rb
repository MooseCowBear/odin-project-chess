require_relative './euclid.rb'
require_relative './path_checker.rb'

require 'set'

class King
  include Euclid
  include PathChecker

  attr_reader :distances, :color
  attr_accessor :moved

  def initialize(color = "white")
    @distances = Set.new([1.0, Math.sqrt(2)])
    @moved = false
    @color = color
  end

  def to_s 
    color == "white" ? "\u{2654}" : "\u{265A}"
  end

  def get_start_position
    color == "black" ? [0, 4] : [7, 4]
  end

  def valid_move?(board, start_idx, end_idx)
    y1, x1 = start_idx
    y2, x2 = end_idx
    dist = distance(x1, y1, x2, y2)
    distances.include?(dist)
  end

  def get_adjacent_positions(position)
    adjacent = []
    y, x = position
    (y - 1).upto(y + 1) do |i|
      (x - 1).upto(x + 1) do |j|
        if [i, j] != position
          adjacent << [i, j] if i.between?(0, 7) && j.between?(0, 7)
        end
      end
    end
    adjacent
  end
end