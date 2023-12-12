require_relative "./pin.rb"

class PinFinder
  attr_reader :board, :king

  def initialize(board, king)
    @board = board
    @king = king
  end

  def get_pins
    pins = []
    _, teammates = board.closest_neighbors(square: king.position, alliance: king)
    pp teammates

    teammates.each do |teammate|
      possible_attack = board.closest_neighbor_in_direction(square: teammate.position, direction: walkout_direction(teammate))
      if board.under_attack?(from: possible_attack, to: king.position, alliance: king)
        pins << Pin.new(piece: teammate, attacker: board.get_piece(possible_attack))
      end
    end
    pins
  end

  def walkout_direction(teamate)  
    delta_row = teamate.position[0] - king.position[0]
    delta_col = teamate.position[1] - king.position[1]

    board.directions.select { |d| match(delta_row, d[0]) && match(delta_col, d[1]) }.first
  end

  def match(one, two) 
    (one == 0 && two == 0) || (one > 0 && two > 0) || (one < 0 && two < 0)
  end 
end