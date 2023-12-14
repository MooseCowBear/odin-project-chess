require_relative "../move_converter"

class HumanPlayer
  attr_reader :name, :move_converter

  def initialize(name:)
    super
    @move_converter = MoveConverter.new
  end

  def move(moves) 
      move = gets.chomp
      move_converter.converted_move(move, moves)
    end
  end
end