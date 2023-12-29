require_relative "../move_converter"
require_relative "./player"

class HumanPlayer < Player
  attr_reader :move_converter

  def initialize(name:, color:)
    super
    @move_converter = MoveConverter.new
  end

  def move(moves) 
    move = STDIN.gets.chomp
    move_converter.convert(move, moves)
  end

  def promotion_choice
    gets.chomp.downcase
  end
end