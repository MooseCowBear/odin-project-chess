require_relative "./player"

class ComputerPlayer < Player
  def initialize
    super(name: "Hal")
  end

  def move(moves) # this is returning the move already in form that chess wants
    move = moves.sample
  end
end