class HumanPlayer
  attr_reader :name 

  def initialize(name)
    @name = name
  end

  def get_player(color)
    puts "Enter a name for person playing #{color}:"
    name = gets.chomp
    HumanPlayer.new(name)
  end
end