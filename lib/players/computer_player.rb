require_relative "./player"

class ComputerPlayer < Player
  def initialize
    super(name: "Hal", color: "black")
  end

  def move(moves)
    move = moves.sample
  end

  def promotion_choice
    "queen"
  end
end