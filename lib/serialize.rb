module Serialize

  def save_game(game)
    filename = make_filename(game)

    Dir.mkdir 'saves' unless Dir.exist? 'saves'

    File.open('saves/' + filename, 'w+') { |f| f.write(Marshal.dump(game)) } 
  end
  
  def make_filename(game)
    name = game.played_on.strftime("%d_%m_%Y_%I_%M_%p")
    
    name + '.txt'
  end
  
  def load_games
    path =  File.expand_path('../saves', __dir__)
    files = Dir["#{path}/*.txt"]
    games = []

    files.each do |f|
      reconstructed = Marshal.load(File.binread(f))

      games << reconstructed
    end
    games
  end

  def unfinished_games
    games = load_games

    games.select do |game| 
      game.winner.nil? && game.num_moves < 75 && game.stalemate == false
    end
  end

  def display_game_choices(games)
    games.each_with_index do |game, i|
      puts "#{i + 1}: #{game.player_white.name} vs. #{game.player_black.name} #{game.played_on.strftime("%d/%m/%Y %I:%M %p")}"
    end
  end

  def validate_choice(input, games)
    input.between?(1, games.length)
  end

  def ask_to_save(game)
    puts "Would you like to save? y/n"

    input = gets.chomp.downcase

    if input == 'y' || input == 'yes'
      save_game(game)
    end
  end
end