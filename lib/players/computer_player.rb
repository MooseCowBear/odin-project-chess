class ComputerPlayer
  attr_reader :name

  def initialize
    @name = "Hal"
  end

  def make_move(check, unspecial_moves, castles, en_passant)
    moves = moves_to_arr(check, unspecial_moves, castles, en_passant)
    
    moves.sample
  end

  def moves_to_arr(check, unspecial_moves, castles, en_passant)
    arr = []
    unspecial_moves.each do |k, v|
      v.each do |elem|
        arr << [k, elem]
      end
    end
    en_passant.each do |elem|
      arr << [elem.from , elem.to]
    end
    unless check 
      castles.each do |elem|
        arr << [elem.king_start, elem.king_end]
      end
    end
    arr
  end
end