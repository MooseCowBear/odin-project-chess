require 'fileutils'

module Serialize

  def save_game(game)
    filename = make_filename
    Dir.mkdir 'saves' unless Dir.exist? 'saves'
    File.open('saves/' + filename, 'wb') {|f| f.write(Marshal.dump(game))}
  end
  
  def make_filename(game)
    name = game.played_on.strftime("%d/%m/%Y_%I:%M_%p")
    '/' + name 
  end
  
  def load_games
    files = Dir.glob("*.txt")
    games = []
    files.each do |f|
      f_name = File.basename(f)
      reconstructed = Marshal.load(File.binread(f_name))
      games << reconstructed
    end
    games
  end

  def unfinished_games
    games = load_games
    games.select { |game| game.winner.nil? && game.num_moves < 75 && game.stalemate = false}
  end

  def display_game_choices(games)
    games.each_with_index do |game, i|
      puts "#{i + 1}: #{game.player_white.name} vs. #{game.player_black.name} #{game.played_on.strftime("%d/%m/%Y")}"
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