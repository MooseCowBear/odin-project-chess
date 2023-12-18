module Setup 
  def setup
    get_players(two_player_mode?)
    set_starting_board
    set_kings
  end

  def two_player_mode?
    loop do
      puts "Would you like a single player game? y/n"
      input = gets.chomp.downcase

      if input == 'y' || input == 'yes'
        return true
      elsif input == 'n' || input == 'no'
        return false
      end
    end
  end

  def get_players(two_player_mode)
    @player_white, @player_black = Player.create(two_player_mode)
  end

  def set_starting_board
    @board = board.new
    white_pieces = starting_pieces("white")
    black_pieces = starting_pieces("black")
    place_pieces(white_pieces + black_pieces)
  end

  def place_pieces(pieces)
    pieces.each do |piece|
      board.update(position: piece.position, value: piece)
    end
  end

  def starting_pieces(color)
    row = color == "white" ? 7 : 0
    direction = color == "white" ? -1 : 1

    pieces = []
    pieces << King.new(color: color, position: [row, 4])
    pieces << Queen.new(color: color, position: [row, 3])

    [0, 7].each do |col|
      pieces << Rook.new(color: color, position: [row, col])
    end

    [1, 6].each do |col|
      pieces << Knight.new(color: color, position: [row, col])
    end

    [2, 5].each do |col|
      pieces << Bishop.new(color: color, position: [row, col])
    end

    (0..7).each do |col|
      Pawn.new(color: color, position: [row + direction, col])
    end
  end

  def set_kings
    @white_king = board.get_piece([7, 4])
    @black_king = board.get_piece([0, 4])
  end
end