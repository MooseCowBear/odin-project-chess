require_relative "../move_converter"
require_relative "./player"

class HumanPlayer < Player
  attr_reader :move_converter

  def initialize(name:)
    super
    @move_converter = MoveConverter.new
  end

  def move(moves) 
    move = gets.chomp
    move_converter.convert(move, moves)
  end
end