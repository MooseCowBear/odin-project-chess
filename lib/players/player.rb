class Player 
  def initialize(name:)
    @name = name
  end

  def move(moves)
    raise Exception.new "This method needs to be defined in the subclass"
  end
end