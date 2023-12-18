class Player 
  attr_reader :name
  
  def initialize(name:, color:)
    @name = name
    @color = color
  end

  def self.create(two_player)
    puts "Enter a name for player one:"
    name_one = gets.chomp
    player_one = HumanPlayer.new(name: name_one, color: "white")
    player_two = ComputerPlayer.new

    if two_player
      puts "Enter a name for player two:" 
      name_two = gets.chomp
      player_two = HumanPlayer.new(name: name_two, color: "black")
    end
    [player_one, player_two]
  end

  def move(moves)
    raise Exception.new "This method needs to be defined in the subclass"
  end
end