require_relative "../moves/move.rb"

class Piece 
  attr_reader :color, :promotable
  attr_accessor :moved, :position

  def initialize(color:, position:, promotable:)
    @color = color
    @moved = false 
    @promotable = promotable 
    @position = position
  end

  def valid_moves(from:, board:)
    raise Exception.new "This method needs to be defined in the subclass"
  end

  def valid_move?(to:, from:, board:)
    raise Exception.new "This method needs to be defined in the subclass"
  end

  def teammate?(other) 
    color == other&.color
  end

  def opponent?(other)
    color != other&.color
  end

  def to_s
    raise Exception.new "This method needs to be defined in the subclass"
  end

  def white?
    color == "white"
  end

  def last_row 
    white? ? 0 : 7
  end
end