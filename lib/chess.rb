require_relative './euclid.rb' 
require_relative './king.rb'
require_relative './queen.rb'
require_relative './bishop.rb'
require_relative './knight.rb'
require_relative './rook.rb'
require_relative './pawn.rb'
require_relative './pin.rb'
require_relative './en_passant.rb'
require_relative './castle.rb'
require_relative './board_check.rb'
require_relative './human_player.rb'
require_relative './computer_player.rb'
require_relative './serialize.rb'

class Chess
  include Euclid
  include BoardCheck
  include Serialize

  attr_accessor :single_player, :player_white, :player_black, 
    :board, :turn_white, :white_king_position, 
    :black_king_position, :en_passant, :checks, :pins, :stalemate, 
    :checkmate, :played_on, :winner

  def initialize
    @single_player = true
    @player_white = nil 
    @player_black = nil
    @board = get_starting_board 
    @turn_white = true
    @white_king_position = [7, 4]
    @black_king_position = [0, 4] 
    @en_passant = [] 
    @stalemate = false
    @checkmate = false
    @winner = nil
    @checks = []
    @pins = []
    @played_on = Time.now
  end

  def self.play
    game = Chess.new
    new_game = true
    unfinished = game.unfinished_games

    unless unfinished.empty?
      loop do
        answered = false
        puts "Would you like to load a saved game?"

        load = gets.chomp.downcase

        if load == 'y' || load == 'yes'
          loop do 
            puts "Enter the number of the game you would like to load."

            game.display_game_choices(unfinished)

            choice = gets.chomp.to_i

            if game.validate_choice(choice, unfinished)
              game = unfinished[choice - 1]
              new_game = false
              answered = true
              break
            end
          end
        elsif load == 'n' || load == 'no'
          answered = true
          break
        end
        break if answered
      end
    end
    game.set_mode if new_game
    
    game.play_game(new_game)
  end

  def set_mode
    loop do
      puts "Would you like a single player game? y/n"

      input = gets.chomp.downcase

      return if input == 'y' || input == 'yes'

      if input == 'n' || input == 'no'
        self.single_player = false
        return 
      end
    end
  end

  def play_game(new_game)
    get_players if new_game

    print_board("current")

    display_turns

    announce_result

    print_board("final")

    save_game(self) #if the game has been played to completion we want exclude it from unfinished games by updating its state
  end

  def get_players
    if single_player
      self.player_white = HumanPlayer.get_player("white")

      self.player_black = ComputerPlayer.new
    else
      self.player_white = HumanPlayer.get_player("white")

      self.player_black = HumanPlayer.get_player("black")
    end
  end

  def get_starting_board
    self.board = Array.new(8) { Array.new(8) } 

    players = ["white", "black"]

    players.each do |player| 
      king = King.new(player)
      m, n = king.get_start_position
      self.board[m][n] = king

      queen = Queen.new(player)
      m, n = queen.get_start_position
      self.board[m][n] = queen

      1.upto(2) do |i|
        rook = Rook.new(i, player)
        m, n = rook.get_start_position
        self.board[m][n] = rook

        bishop = Bishop.new(i, player)
        m, n = bishop.get_start_position
        self.board[m][n] = bishop

        knight = Knight.new(i, player)
        m, n = knight.get_start_position
        self.board[m][n] = knight
      end

      1.upto(8) do |i|
        pawn = Pawn.new(i, player)
        m, n = pawn.get_start_position
        self.board[m][n] = pawn
      end
    end 
    board
  end

  def display_turns
    take_turn until checkmate || stalemate
  end

  def take_turn 
    nonspecial_moves = nil 

    king = turn_white ? white_king_position : black_king_position

    p_and_c = get_checks_and_pins(king, player_color, opponent_color)

    update_pins_checks(p_and_c)

    if checks.length > 0
      nonspecial_moves = from_check_moves
    else
      nonspecial_moves = non_check_moves
    end

    castles = available_castles

    if checks.length > 0
      self.checkmate = checkmate?(nonspecial_moves) 

      announce_check unless checkmate
      announce_checkmate if checkmate

      record_winner if checkmate
    else
      self.stalemate = stalemate?(nonspecial_moves, castles) 
    end

    move = get_move(nonspecial_moves, castles) 

    piece = get_piece(move[0])
 
    make_move(piece, move[0], move[1], castles)

    annouce_move(move)
   
    update_en_passant(piece, move[0], move[1])
  
    promote_pawn(move[1])
    
    self.turn_white = !turn_white

    print_board("current")

    ask_to_save(self)
  end

  def get_move(nonspecial_moves, castles)
    if single_player && !turn_white
      c = checks.length > 0
      player_black.make_move(c, nonspecial_moves, castles, en_passant)
    else
      get_human_move(nonspecial_moves, castles)
    end
  end

  def get_human_move(nonspecial_moves, castles) 
    player = turn_white ? player_white : player_black

    puts "Enter a move for #{player.name}." 

    loop do
      move = gets.chomp

      if move_on_board?(move)
        move = convert_move(move)

        return move if legal?(move, nonspecial_moves, castles)
      end
      issue_move_warning
    end
  end

  def issue_move_warning
    puts "All moves must be legal."

    puts "Moves should be of the form a1b2."

    puts "Enter a legal move:"
  end

  def legal?(move, nonspecial_moves, castles)
    start_pt, end_pt = move
    
    if checks.length > 0
      in_non_special_move?(start_pt, end_pt, nonspecial_moves) || 
      in_enpassant?(start_pt, end_pt)
    else
      in_non_special_move?(start_pt, end_pt, nonspecial_moves) || 
      in_enpassant?(start_pt, end_pt) || 
      in_castles?(start_pt, end_pt, castles)
    end
  end

  def make_move(piece, start_pt, end_pt, castles) 
    self.board[start_pt[0]][start_pt[1]] = nil

    self.board[end_pt[0]][end_pt[1]] = piece

    update_king(piece, end_pt)

    update_pawn(piece)

    update_rook(piece)

    if in_castles?(start_pt, end_pt, castles)
      c = castles.select { |elem| elem.king_start == start_pt && elem.king_end == end_pt }

      rook_s = c.rook_start
      rook_e = c.rook_end

      self.board[rook_e[0]][rook_e[1]] = board[rook_s[0]][rook_s[1]]

      self.board[rook_s[0]][rook_s[1]] = nil

    elsif in_enpassant?(start_pt, end_pt)
      ep = en_passant.select { |elem| elem.from == start_pt && elem.to == end_pt }

      m, n = ep[0].opponent_pawn_pos

      self.board[m][n] = nil
    end
  end

  def move_on_board?(input)
    !!/^[A-Ha-h]{1}[1-8]{1}[A-Ha-h]{1}[1-8]{1}$/.match(input) 
  end

  def convert_move(move)
    #need to convert inputs like a4b2 to pairs of matrix indices
    #letter is column, number is row

    m = move.downcase 
    [
      [convert_row(m[1]), convert_column(m[0])], 
      [convert_row(m[3]), convert_column(m[2])]
    ]
  end

  def print_board(state)
    puts "\nThe #{state} board is: \n" 
    puts "    a   b   c   d   e   f   g   h  "
    puts "   ___ ___ ___ ___ ___ ___ ___ ___ "
  
    row_label = 8
    8.times do |row_idx|
      line = "#{row_label} |"

      board[row_idx].each do |elem|
        if elem.nil?
          line += " #{elem.to_s}  |"
        else 
          line += " #{elem.to_s} |"
        end
      end
      puts line

      puts "   ___ ___ ___ ___ ___ ___ ___ ___ "

      row_label -= 1
    end
    puts ""
  end

  def announce_result
    unless winner.nil?
      puts "Congratulations, #{winner.name}!"
    else 
      puts "It's a draw."
    end
  end

  def annouce_move(move)
    player = turn_white ? player_white : player_black

    puts "#{player.name} moved #{revert_move(move[0])} to #{revert_move(move[1])}."
  end

  #methods for game state

  def checkmate?(moves)
    moves.empty? 
  end
  
  def stalemate?(moves, castles)
    moves.empty? && castles.empty? && en_passant.empty?
  end
  
  def record_winner
    self.winner = turn_white ? player_black : player_white
  end

  # the heavy lifitng. 
  # all the methods relating to getting legal moves

  def get_checks_and_pins(king, p_color, o_color, want_pins = true)
    #strategy: look at king position.
    #go out in all directions looking for first opponent elem. 
    #to use this method to check if a square is under attack
    #ie. the king would be in check if he moved there
    #pass square as the first parameter and set want_pins to false

    moves = Hash.new { |h, k| h[k] = [] }

    directions = [ [0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1] ]

    directions.each do |d|
      m = 1
      square = [king[0] + d[0], king[1] + d[1]] 
      possible_pin = nil

      while on_board?(square)
        piece = get_piece(square)

        if piece&.color == p_color && possible_pin.nil?
          if want_pins
            possible_pin = Pin.new(piece, square, king) 
          else
            break 
          end
        elsif piece&.color == p_color && !possible_pin.nil? #one possible pin + one possible pin = zero actual pins
          break
        elsif piece&.color == o_color
          if possible_pin.nil?

            attacking = mechanically_correct(piece, square, king) 

            moves["checks_arr"] << [piece, square, king] if attacking
            break 
          else 
            #now checking whether possible pin is actually removing it, 
            #and testing whether the opponent piece we hit can attack
            m = possible_pin.position[0]
            n = possible_pin.position[1]

            get_test_board(m, n)

            attacking = mechanically_correct(piece, square, king) 

            possible_pin.update_defense(square) if attacking

            moves["pins_arr"] << possible_pin if attacking 

            revert_board(possible_pin.identity, m, n) 
            break 
          end
        end
        m += 1
        square = get_square(king, d, m)
      end #end while loop
    end #end directions loop

    knight_positions = [ [1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1] ]

    knight_positions.each do |p|
      #nothing can be a pin for a knight, so just check for check
      row = king[0] + p[0]
      col = king[1] + p[1]

      if on_board?([row, col])
        piece = get_piece([row, col])
        moves["checks_arr"] << [piece, [row, col], king] if piece.is_a?(Knight) && piece.color == o_color 
      end
    end
    moves
  end

  def from_check_moves
    #if double check, then can only move the king
    #otherwise, we need to check for defensive moves
    #and trivial pin moves

    moves = noncastling_king_moves

    if checks.length == 1
      king = turn_white ? white_king_position : black_king_position

      moves = moves.merge(defender_moves(king, checks[0][1]))

      moves = moves.merge(pin_moves)
    end
    moves
  end

  def non_check_moves
    #moves when not in check include king,
    #pin moves, nonpin moves 
    #(castling and en passant moves are determined elsewhere)

    moves = noncastling_king_moves

    moves = moves.merge(pin_moves)

    moves.merge(unpinned_moves)
  end

  def noncastling_king_moves 
    #getting the moves the king can make without putting himself in check

    king_pos = curr_king

    king = get_piece(king_pos)

    king_moves = Hash.new { |h, k| h[k] = [] }

    get_test_board(king_pos[0], king_pos[1]) #don't want a check to be blocked bc of king

    adj = king.get_adjacent_positions(king_pos)
    
    adj.each do |pos|
      orig_piece = get_piece(pos)

      next if orig_piece&.color == player_color #if its a teammate, skip. can't move there

      board[pos[0]][pos[1]] = king 

      m = get_checks_and_pins(pos, player_color, opponent_color, false) 

      king_moves[king_pos] << pos if m.empty? 

      board[pos[0]][pos[1]] = orig_piece 
    end
    revert_board(king, king_pos[0], king_pos[1]) 

    king_moves
  end

  def defender_moves(king, opponent)
    #getting moves that either capture a checking piece
    #or that block the line of attack for a checking piece
    #includes marking enpassant moves if they can defend

    squares = squares_in_range(king, opponent)

    defenders = []

    squares.each do |sq|
      res = get_checks_and_pins(sq, opponent_color, player_color, false) #switch colors

      defenders += res["checks_arr"] if res.has_key?("checks_arr")
    end

    enpassant_rescues 
    moves = convert_defenders(defenders)
  end

  def enpassant_rescues
    rescues = en_passant.select { |elem| elem.opponent_pawn_pos == checks[0][1] }

    rescues.each { |e| e.rescue = true } 
  end

  def convert_defenders(defenders)
    #so we can combine defender moves with king moves in a single hash
    #need to exclude king moves, bc defender_moves does not

    conversion = Hash.new { |h, k| h[k] = [] }

    defenders.each do |elem|
      conversion[elem[1]] << elem[2] unless elem[0].is_a?(King)
    end
    conversion
  end

  def pin_moves
    #getting moves a pin can make while remaining a pin

    moves = Hash.new { |h, k| h[k] = [] }
    pins.each do |pin| 
      squares = squares_in_range(pin.defending_position, pin.defending_against)

      squares.each do |sq|
        good_move = mechanically_correct(pin.identity, pin.position, sq)

        moves[pin.position] << sq if good_move && sq != pin.position
      end
    end
    moves
  end

  def squares_in_range(king, opponent) 
    #getting defender moves and pin moves involves
    #checking the "line" between the king and an opponent
    #this fuction grabs all the squares on that line
    squares = []

    slope = slope(king[1], king[0], opponent[1], opponent[0])

    x = king[1] 
    y = king[0] 

    if slope.nil?
      dir = king[0] < opponent[0] ? 1 : -1

      until y == opponent[0]
        y += dir

        squares << [y, x]
      end
    else
      dir = king[1] < opponent[1] ? 1 : -1

      until x == opponent[1]
        x += dir

        y += slope * dir

        squares << [y.to_i, x.to_i]
      end
    end
    squares 
  end

  def unpinned_moves
    #find all nonpin teammates 
    #and determine their moves

    possible_moves = Hash.new

    board.each_with_index do |row, m| 
      row.each_with_index do |piece, n|
        next if pins.any? { |pin| pin.identity == piece } || piece&.color != player_color || piece.is_a?(King)

        moves = piece.moves(board, [m, n])

        possible_moves = possible_moves.merge(moves)
      end
    end
    possible_moves
  end

  #now, the special moves...
  #castling
  def available_castles
    castles = []
    q = queen_side
    k = king_side

    if castle?(q)
      castles << Castle.new(q[:king], [q[:king][0], q[:king][1] - 2], q[:rook], [q[:king][0], q[:king][1] - 1])
    end

    if castle?(k)
      castles << Castle.new(k[:king], [k[:king][0], k[:king][1] + 2], q[:rook], [q[:king][0], q[:king][1] + 1])
    end
    castles 
  end

  def castle?(side)
    return false unless king_eligible(side[:king]) && rook_eligible(side[:rook])

    dir = side[:king][1] < side[:rook][1] ? 2 : -2

    safe_passage?(side[:king][0], side[:king][1], side[:king][1] + dir) && 
    clear_passage?(side[:king][0], side[:king][1], side[:rook][1])
  end

  def queen_side
    king_pos = turn_white ? [7, 4] : [0, 4] 
    rook_pos = turn_white ? [7, 0] : [0, 0]

    return { :king => king_pos, :rook => rook_pos }
  end

  def king_side
    king_pos = turn_white ? [7, 4] : [0, 4]
    rook_pos = turn_white ? [7, 7] : [0, 7]

    return { :king => king_pos, :rook => rook_pos }
  end

  def king_eligible(pos)
    board[pos[0]][pos[1]].is_a?(King) && !board[pos[0]][pos[1]].moved
  end

  def rook_eligible(pos)
    board[pos[0]][pos[1]].is_a?(Rook) && !board[pos[0]][pos[1]].moved
  end

  def safe_passage?(row, min, max)
    if min > max
      min, max = max, min
    end

    min.upto(max) do |col| 
      checked = get_checks_and_pins([row, col], player_color, opponent_color, false) 

      return false unless checked["checks_arr"].empty? 
    end
    true
  end

  def clear_passage?(row, min, max)
    if min > max
      min, max = max, min
    end

    (min + 1).upto(max - 1) do |col|
      return false unless board[row][col].nil? 
    end
    true
  end

  #en passant 
  def update_en_passant(piece, start_pt, end_pt)
    self.en_passant = []

    return unless piece.is_a?(Pawn) && distance(start_pt[1], start_pt[0], end_pt[1], end_pt[0]) == 2.0 

    left = left_neighbor(end_pt)

    right = right_neighbor(end_pt)

    self.en_passant << left unless left.nil? 

    self.en_passant << right unless right.nil?
  end

  def right_neighbor(end_pt)
    return nil if end_pt[1] + 1 > 7 || !opponent_pawn?(end_pt[0], end_pt[1] + 1)

    EnPassant.new([end_pt[0], end_pt[1] + 1], ep_end_position(end_pt), end_pt)
  end

  def left_neighbor(end_pt)
    return nil if end_pt[1] - 1 < 0 || !opponent_pawn?(end_pt[0], end_pt[1] - 1)

    EnPassant.new([end_pt[0], end_pt[1] - 1], ep_end_position(end_pt), end_pt) 
  end

  def opponent_pawn?(m, n)
    opponent_color = turn_white ? "black" : "white"

    board[m][n].is_a?(Pawn) && board[m][n].color == opponent_color
  end

  def ep_end_position(end_pt)
    turn_white ? [end_pt[0] + 1, end_pt[1]] : [end_pt[0] - 1, end_pt[1]]
  end

  #pawn promotion
  def promotion?(end_pt)
    opponent_side = turn_white ? 0 : 7

    board[end_pt[0]][end_pt[1]].is_a?(Pawn) && end_pt[0] == opponent_side
  end

  def promote_pawn(position)
    if promotion?(position)
      choice = get_promotion_choice

      self.board[position[0]][position[1]] = new_piece(choice)
    end
  end

  def get_promotion_choice
    puts "How would you like to promote your pawn?"

    loop do 
      puts "The options are: Queen, Bishop, Rook, Knight."

      choice = gets.chomp.downcase

      return choice if valid_promotion_choice(choice)
    end
  end

  def valid_promotion_choice(input)
    ["queen", "bishop", "rook", "knight"].include?(input)
  end

  def new_piece(choice)
    case choice
    when "queen"
      return Queen.new(player_color)

    when "bishop"
      return Bishop.new(0, player_color)

    when "rook"
      return Rook.new(0, player_color)

    when "knight"
      return Knight.new(0, player_color)
    end
  end

  #small helper functions
  private

  def announce_check
    puts "Check."
  end

  def announce_checkmate
    puts "Checkmate."
  end

  def update_king(piece, end_pt)
    if piece.is_a?(King)
      piece.moved = true

      if turn_white
        self.white_king_position = end_pt
      else
        self.black_king_position = end_pt
      end
    end
  end

  def update_pawn(piece)
    piece.moved = true if piece.is_a?(Pawn)
  end

  def update_rook(piece)
    piece.moved = true if piece.is_a?(Rook)
  end

  def in_non_special_move?(start_pt, end_pt, nonspecial_moves)
    nonspecial_moves.has_key?(start_pt) && nonspecial_moves[start_pt].include?(end_pt)
  end

  def in_enpassant?(start_pt, end_pt)
    if checks.length > 0
      en_passant.any? { |elem| elem.from == start_pt && elem.to == end_pt && elem.rescue }
    else
      en_passant.any? { |elem| elem.from == start_pt && elem.to == end_pt }
    end
  end

  def in_castles?(start_pt, end_pt, castles)
    castles.any? { |elem| elem.king_start == start_pt && elem.king_end == end_pt }
  end

  def get_square(pos, direction, multiplier)
    d = direction.map { |elem| elem * multiplier }
    [pos[0] + d[0], pos[1] + d[1]] 
  end

  def update_pins_checks(hash)
    self.pins = hash["pins_arr"]
    self.checks = hash["checks_arr"]
  end

  def mechanically_correct(piece, start_pos, end_pos)
    piece.valid_move?(self.board, start_pos, end_pos) || 
    in_enpassant?(start_pos, end_pos)
  end

  def curr_king 
    turn_white ? white_king_position : black_king_position
  end

  def player_color 
    turn_white ? "white" : "black"
  end

  def opponent_color
    turn_white ? "black" : "white"
  end

  def get_test_board(m, n)
    self.board[m][n] = nil
  end
  
  def revert_board(piece, m, n)
    self.board[m][n] = piece
  end

  def convert_column(char)
    char.ord - 97
  end

  def convert_row(char)
    8 - char.to_i
  end

  def get_piece(pos)
    board[pos[0]][pos[1]]
  end

  def revert_move(move)
    letter = (move[1] + 97).chr

    num = 8 - move[0]

    "#{letter}#{num}"
  end
end