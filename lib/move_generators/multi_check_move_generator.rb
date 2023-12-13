require_relative "./move_generator.rb"

class MultiCheckMoveGenerator < MoveGenerator
  def moves
    king_moves
  end
end