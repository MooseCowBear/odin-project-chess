require_relative "./player"

class ComputerPlayer < Player
  def initialize
    super(name: "Hal", color: "black")
  end

  def move(moves) # this is returning the move already in form that chess wants
    move = moves.sample
  end

  def promotion_choice
    "queen"
  end
end