require_relative './euclid.rb' #need for intersection methods
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

class Chess
  include Euclid

  attr_accessor :player_white, :player_black, 
    :board, :turn_white, :white_king_position, 
    :black_king_position, :num_moves, :en_passant, 
    :checks, :pins, :stalemate, :checkmate

  def initialize
    @player_white = nil 
    @player_black = nil
    @board = get_starting_board 
    @turn_white = true
    @white_king_position = [7, 4]
    @black_king_position = [0, 4] 
    @num_moves = 0
    @en_passant = [] #will hold EnPassant objects, upto 2 possible
    @stalemate = false
    @checkmate = false
    @winner = nil

    @checks = []
    @pins = []
  end

  def play #assumes new game
    self.player_white = get_player("white")

    self.player_black = get_player("black")

    display_turns

    print_board("final")

    announce_result
  end

  def announce_result
    unless winner.nil?
      puts "Congratulations, #{winner}!"
    else 
      puts "It's a draw."
    end
  end

  def get_player(color)
    puts "Enter a name for person playing #{color}:"
    name = gets.chomp
    name
  end

  def get_starting_board
    self.board = Array.new(8) { Array.new(8) } #later, update to read in board from file

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
    take_turn until checkmate || stalemate || num_moves >= 75 
  end

  def take_turn 
    print_board("current")

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
      record_winner if checkmate
    else
      self.stalemate = stalemate?(nonspecial_moves, castles) 
    end

    move = get_human_move(nonspecial_moves, castles)

    piece = get_piece(move[0])
 
    make_move(piece, start_pt, end_pt, castles)
   
    update_en_passant(piece, start_pt, end_pt)
  
    promote_pawn(end_pt)
    
    self.turn_white = !turn_white
    
    self.num_moves += 1

    #ask to save (eventually)

  end

  def get_piece(pos)
    board[pos[0]][pos[1]]
  end

  def get_human_move(nonspecial_moves, castles) 
    player = turn_white ? player_white : player_black

    puts "Enter a move for #{player}." 

    puts "Moves should be of the form a1b2."

    loop do
      move = gets.chomp

      if move_on_board(move)
        move = convert_move(move)

        return move if legal?(move, nonspecial_moves, castles)
      end
      issue_move_warning
    end
  end

  def issue_move_warning
    puts "All moves must be legal."
    puts "Enter a legal move:"
  end

  def legal?(move, nonspecial_moves, castles)
    start_pt, end_pt = move
    
    if checks.length > 0
      in_non_special_move?(start_pt, end_pt) || in_enpassant?(start_pt, end_pt)
    else
      in_non_special_move?(start_pt, end_pt) || in_enpassant?(start_pt, end_pt) || in_castles?(start_pt, end_pt)
    end
  end

  def in_non_special_move?(start_pt, end_pt)
    nonspecial_moves.has_key?(start_pt) && nonspecial_moves[start_pt].include?(end_pt)
  end

  def in_enpassant?(start_pt, end_pt)
    if checks.length > 0:
      en_passant.any? { |elem| elem.from == start_pt && elem.to == end_pt && elem.rescue }
    else
      en_passant.any? { |elem| elem.from == start_pt && elem.to == end_pt }
    end
  end

  def in_castles?(start_pt, end_pt)
    castles.any? { |elem| elem.king_start == start_pt && elem.king_end == end_pt }
  end

  def make_move(piece, start_pt, end_pt, castles) 
    self.board[start_pt[0]][start_pt[1]] = nil

    self.board[end_pt[0]][end_pt[1]] = piece

    if in_castles?(start_pt, end_pt)
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
    !!/^[A-Ha-h]{1}[1-8]{1}[A-Ha-h]{1}[1-8]{1}$/.match(input) #test this
  end

  def convert_move(move)
    #need to convert inputs like a4b2 to pairs of matrix indices
    #letter is column, number is row
    m = move.downcase 
    [
      [covert_row(m[0]), convert_column(m[1])], 
      [[convert_row(m[2])], convert_column(m[3])]
    ]
  end

  def print_board(state)
    puts "\nThe #{state} board is: \n" #a little bit of spacing?
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
  end

  #start refactor functions

  def get_checks_and_pins(king, p_color, o_color, want_pins = true)
    #strategy: look at king position. 
    #go out in all directions looking for first opponent elem. 

    moves = {
      :pins_arr => [],
      :checks_arr => []
    }

    directions = [ [0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1] ]

    directions.each do |d|
      m = 1
      square = [king[0] + d[0], king[1] + d[1]] 
      possible_pin = nil

      while on_board?(square)
        piece = board[square[0]][square[1]]

        next if piece.nil?

        if piece.color == p_color && possible_pin.nil?
          if want_pins
            possible_pin = Pin.new(piece, square, king) 
          else
            break #if we are just checking pass thrus for castle or king moves, then we don't care about pin for square king is thinking about moving to or thru
          end
        elsif piece.color == p_color && !possible_pin.nil? #did we hit a second teammate? niether are pins and can't have a check
          break
        elsif piece.color == o_color
          if possible_pin.nil?
            #can this opponent piece attack?
            attacking = mechanically_correct(piece, square, king) 
            moves[checks_arr] << [piece, square, king] if attacking
            break 
          else 
            #the check for whether our possible pin is an actual pin
            #ie. if the pin isn't there, does opponent have an attack?
            m = possible_pin[1][0]
            n = possible_pin[1][1]
            get_test_board(m, n)

            attacking = mechanically_correct(piece, square, king) 
            possible_pin.update_defense(square) if attacking
            moves[pins_arr] << possible_pin if attacking 

            revert_board(possible_pin.identity, m, n) 
            break 
          end
        end
        m += 1
        square = get_square(d, m)
      end #end while loop
    end #end directions loop

    knight_positions = [ [1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1] ]

    knight_positions.each do |p|
      #the check is: is the piece on the square an opponent knight
      row = king[0] + p[0]
      col = king[1] + p[1]

      piece = board[row][col]
      moves[checks_arr] << [piece, [row, col], king] if piece.is_a?(Knight) && piece.color == o_color 
    end
    moves
  end

  #what moves can be made in check
  # 1. noncastling_king_moves (double or single)
  # 2. defender moves (single)

  # what moves can be made not in check
  # 1. noncastling king moves
  # 2. pin moves 
  # 3. castling moves (if otherwise available)
  # 4. any piece that is not a pin can make any mechanically correct move 
 
  # added method(s) to generate moves of unpinned pieces (ie 4) - need to update classes so that it will work

  #two methods to aggregate non special moves so less to pass to make move method
  def from_check_moves
    moves = noncastling_king_moves

    if checks.length == 1
      king = turn_white? white_king_position : black_king_position

      moves = moves.merge(defender_moves(king, checks[0][1]))

      moves = moves.merge(pin_moves)
    end
    moves
  end

  def non_check_moves
    moves = noncastling_king_moves

    moves = moves.merge(pin_moves)

    moves.merge(unpinned_moves)
  end

  def noncastling_king_moves 
    #getting the moves the king can make without putting himself in check
    king_pos = curr_king

    king =  board[king_pos[0]][king_pos[1]]
    p_color = player_color
    o_color = opponent_color

    king_moves = Hash.new { |h, k| h[k] = [] }

    adj = king.get_adjacent_positions(king_pos)
    
    adj.each do |pos|
      m = get_checks_and_pins(pos, p_color, o_color, false)

      king_moves[king_pos] << square if m[checks_arr].empty? 
    end
    king_moves
  end

  #ONLY CARE IF IN CHECK by single opponent piece
  def defender_moves(king, opponent)
    #getting moves that either capture a checking piece
    #or that block the line of attack for a checking piece
    squares = squares_in_range(king, opponent)

    defenders = []

    squares.each do |sq|
      res = get_checks_and_pins(sq, opponent_color, player_color, false) #switch colors

      defenders += defenders[checks_arr] #are of form: [piece, piece position, attacking pos] 
    end

    moves = convert_defenders(defenders)

    enpassant_rescues
  end

  def convert_defenders(defenders)
    conversion = Hash.new { |h, k| h[k] = [] }
    defenders.each do |elem|
      conversion[elem[1]] << elem[2]
    end
  end

  def pin_moves
    #getting moves a pin can make while remaining a pin
    moves = Hash.new { |h, k| h[k] = [] }
    pins.each do |pin| 
      squares = squares_in_range(pin.defending_position, pin.defending_against)

      squares.each do |sq|
        good_move = mechanically_correct(pin.identity, pin.position, sq)

        moves[pin.position] << sq if good_move
      end
    end
    moves
  end

  #for getting the moves out of check - also need the possibility that their pawn that i can take en passant is the thing checking me
  #if single check, then want to see if i can moves to any of these squares - if yes, these are possible ways out that do not involve the king moving
  def squares_in_range(king, opponent) #positions
    squares = [opponent]
    slope = slope(king[1], king[0], opponent[1], opponent[0])

    if slope.nil?
      dir = king[0] < opponent[0] ? 1 : -1
      y = king[0]
      x = king[1]

      until x == opponent[0]
        y += 1
        squares << [y, x]
      end
    else
      dir = king[1] < opponent[1] ? 1 : -1
      x = king[1] 
      y = king[0] 

      until x == opponent[0]
        x = x + dir
        y = y + slope * dir
        squares << [y, x]
      end
    end
    squares 
  end

  def unpinned_moves 
    possible_moves = Hash.new

    board.each_with_index do |row, m| 
      row.each_with_index do |piece, n|
        next if pins.any? { |pin| pin.identity == piece } || piece.color != player_color

        m = piece.moves(board, [m, n])

        possible_moves.merge(m)
      end
    end
    possible_moves
  end

  def update_pins_checks(hash)
    self.pins = hash[pins_arr]
    self.checks = hash[checks_arr]
  end

  def enpassant_rescues
    rescues = en_passant.select { |elem| elem.opponent_pawn_pos == checks[0][1] }
    rescues.each { |e| e.rescue = true } 
  end

  def mechanically_correct(piece, start_pos, end_pos)
    piece.valid_move?(board, start_pos, end_pos) || en_passant[start_pos].include?(end_pos)
  end

  #helper functions
  def get_square(direction, multiplier)
    direction.map { |elem| elem * multiplier }
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
    self.board[m, n] = nil
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

  #castling

  def available_castles
    castles = []
    q = queen_side
    k = king_side

    if castle?(q)
      castles << Castle.new(q.king, [q.king[0], q.king[1] - 2], q.rook, [q.king[0], q.king[1] - 1])
    end

    if castle?(k)
      castles << Castle.new(k.king, [k.king[0], k.king[1] + 2], q.rook, [q.king[0], q.king[1] + 1])
    end
    castles #need??
  end

  def castle?(side)
    return false unless king_eligible(side.king) && rook_eligible(side.rook)

    safe_passage?(side.king[0], side.king[1], side.king[1] + 2) && clear_passage?(side.king[0], side.king[1], side.rook[1])
  end

  def queen_side
    king_pos = turn_white ? [7, 4] : [0, 4] #queen at col 3
    rook_pos = turn_white ? [7, 0] : [0, 0]

    return { :king => king_pos, :rook => rook_pos }
  end

  def king_side
    king_pos = turn_white ? [7, 4] : [0, 4]
    rook_pos = turn_white ? [7, 7] : [0, 7]

    return { :king => king_pos, :rook => rook_pos }
  end

  def king_eligible(pos)
    board[king_pos[0]][king_pos[1]].is_a?(King) && !board[king_pos[0]][king_pos[1]].moved
  end

  def rook_eligible(pos)
    board[king_pos[0]][king_pos[1]].is_a?(Rook) && !board[king_pos[0]][king_pos[1]].moved
  end

  def safe_passage?(row, min, max)
    min.upto(max) do |col| 
      x = get_checks_and_pins([row, col], player_color, opponent_color, false) 
      return false unless x[checks_arr].empty? 
    end
    true
  end

  def clear_passage?(row, min, max)
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

  #helper functions for update_en_passant 

  def right_neighbor(end_pt)
    return nil if end_pt[1] + 1 > 7 || !opponent_pawn?(end_pt[0], end_pt[1] + 1)
    EnPassant([end_pt[0], end_pt[1] + 1], ep_end_position(end_pt), end_pt)
  end

  def left_neighbor(end_pt)
    return nil if end_pt[1] - 1 < 0 || !opponent_pawn?(end_pt[0], end_pt[1] - 1)
    EnPassant([end_pt[0], end_pt[1] - 1], ep_end_position(end_pt), end_pt)
  end

  def opponent_pawn?(m, n)
    opponent_color = turn_white ? "black" : "white"

    board[m][n].is_a?(Pawn) && board[m][n].color == opponent_color
  end

  def ep_end_position(end_pt)
    turn_white ? [end_pt[0] - 1, end_pt[1]] : [end_pt[0 + 1], end_pt[1]]
  end

  #end helper functions for enpassant

  #pawn promotion

  def promotion?(end_pt)
    #check after the move has been made whether it was a pawn and end pt was end side of board
    opponent_side = turn_white? 0 : 7
    board[end_pt[0]][end_pt[1]].is_a?(Pawn) && end_pt[0] == opponent_side
  end

  def promote_pawn(position)
    #get player choice of piece, put on board at position
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
      return Queen.new(0, player_color)

    when "bishop"
      return Bishop.new(0, player_color)

    when "rook"
      return Rook.new(0, player_color)

    when "knight"
      return Knight.new(0, player_color)
    end
  end
end