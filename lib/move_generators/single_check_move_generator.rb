require_relative "./move_generator.rb"

class SingleCheckMoveGenerator < MoveGenerator
  def moves
    defender_moves + king_moves
  end

  def defender_moves
    defending_moves = []
    check = checks.first
    defenders, _ = board.closest_neighbors(square: check.position, alliance: check)
    defenders.each do |defender|
      if defender.valid_move?(to: check.position, from: defender.position, board: board)
        defending_moves << Move.new(from: defender.position, to: check.position, piece: defender, captures: check)
      end
    end
    get_enpassant.each do |ep|
      if ep.captures == check
        defending_moves << ep
      end
    end
    defending_moves 
  end
end