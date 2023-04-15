require_relative './euclid.rb' #need for intersection methods
require_relative './king.rb'
require_relative './queen.rb'
require_relative './bishop.rb'
require_relative './knight.rb'
require_relative './rook.rb'
require_relative './pawn.rb'

class Chess
  include Euclid

  attr_accessor :player_white, :player_black, 
    :board, :turn_white, :white_king_position, 
    :black_king_position, :num_moves, :en_passant, 
    :check

  def initialize
    @player_white = nil #get player names at the start of play
    @player_black = nil
    @board = get_starting_board 
    @turn_white = true
    @white_king_position = [7, 4]
    @black_king_position = [0, 4] 
    @num_moves = 0
    @en_passant = Hash.new #hash start => [end] if option (up to 2 keys) - Why is value in an array? because will potentially merge this hash with others of that form
    @check = false
    @winner = nil
  end

  def play
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
    take_turn until !winner.nil? || num_moves >= 75 #or 3 repeated board states?
  end

  def take_turn

    #start turn by checking for check. 

    #get appropriate moves and store (this is castling, moves from check(if in check else leave it empty), king_moves, non check moves - already have enpassant)

    #(now that have moves) announce checkmate or stalemate if applicable

    #if checkmate, record winner (winner is NOT curr player)

    #then get move and validate

    #make move (updating board)

    #update en passant (needs to be before updating turn)

    #PAWN PROMOTION?

    #update whose move it is

    #increment num moves

    #ask to save (eventually)

  end

  def get_move() #needs to take in all the available moves, for check, for not check
    #ask for player move

    #on_board?

    #convert_move if on board, else ask for a move that is on the board. or of the right format

    #is the move legal?, if yes, accept. else ask for a legal move

  end

  def make_move(start_pt, end_pt)
    #was it a pawn? update en passant

    #was it a king? update king position

    #update the board - CASTLING IS GOING TO NEED A SPECIAL METHOD TO MOVE KING IN ACCORDANCE W CASTLING HASH BUT ALSO THE ROOK NEEDS TO MOVE APPROPRIATELY

    #update history (eventually)
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

  def on_board?(move)
    (move.length == 4 && 
    move.downcase[0].between?('a', 'h') && 
    move[2].downcase.between?('a', 'h') && 
    move[1].to_i.between?(1, 8) && 
    move[3].to_i.between?(1, 8))
  end

  def print_board
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

  def update_en_passant(piece, start_pt, end_pt)
    en_passant.clear

    return unless piece.is_a?(Pawn) && distance(start_pt[1], start_pt[0], end_pt[1], end_pt[0]) == 2.0 

    left = left_neighbor(end_pt)

    right = right_neighbor(end_pt)

    ep_position = turn_white ? [end_pt[0] - 1, end_pt[1]] : [end_pt[0 + 1], end_pt[1]] 

    en_passant[left] = [ep_position] unless left.nil? 

    en_passant[right] = [ep_position] unless right.nil?
  end

  #helper functions for update_en_passant
  def right_neighbor(end_pt)
    return nil if end_pt[1] + 1 > 7

    [end_pt[0], end_pt[1] + 1] if opponent_pawn?(end_pt[0], end_pt[1] + 1)
  end

  def left_neighbor(end_pt)
    return nil if end_pt[1] - 1 < 0

    [end_pt[0], end_pt[1] - 1] if opponent_pawn?(end_pt[0], end_pt[1] - 1)
  end

  def opponent_pawn?(m, n)
    opponent_color = turn_white ? "black" : "white"

    board[m][n].is_a?(Pawn) && board[m][n].color == opponent_color
  end

  def move_legal?(move_start, move_end, player_check, king_moves, check_moves, non_check_moves, available_castles)
    if player_check
      check_moves[move_start].include?(move_end)
    else 
      (available_castles[move_start] == move_end ||
      (non_check_moves.include?(move_start) && board[move_start[0]][move_start[1]].valid_move?(board, move_start, move_end)) || 
      king_moves[move_start].include?(move_end) || 
      en_passant[move_start].include?(move_end))
    end
  end

  def checkmate?(check_moves)
    check_moves.empty? && check
  end

  def stalemate?(king_moves, non_check_moves, available_castles)
    #currently not checking for dead positions, bare kings
    king_moves.empty? && non_check_moves.empty? && available_castles.empty? 
  end

  def get_pieces_that_can_move #nondefenders?
    can_move = [] 

    board.each_with_index do |row, m| 
      row.each_with_index do |piece, n|
        next if piece.nil? || piece.color != player_color

        get_test_board(m, n)

        king_position = turn_white ? white_king_position : black_king_position

        pieces_that_check = checked_by(player_color, king_position)

        revert_board(piece, m, n)

        can_move << [m, n] if pieces_that_check.empty? && pawn_free?(piece, m, n)
      end
    end
    can_move
  end

  def player_color 
    turn_white ? "white" : "black"
  end

  def opponent_color
    turn_white ? "black" : "white"
  end

  #helper functions for pieces that can move
  def get_test_board(m, n)
    board[m, n] = nil
  end

  def revert_board(piece, m, n)
    board[m][n] = piece
  end

  def pawn_free?(piece, m, n) #pawn needs an extra check
    return true unless piece.is_a?(Pawn)

    row = piece.color == "white" ? m - 1 : m + 1

    (piece.valid_move?(board, [m, n], [row, n]) || 
    piece.valid_move(board, [m, n], [row, n + 1]) || 
    piece.valid_move(board, [m, n], [row, n - 1]) || 
    en_passant.has_key?([m, n]))
  end

  def available_castles(king_position)
    castles = Hash.new { |h, k| h[k] = [] }

    return castles if board[king_position[0]][king_position[1]].moved

    if board[king_position[0]][0].is_a?(Rook) && !board[king_position[0]][0].moved
      if clear_passage?(rook_position, king_position) && safe_passage?(rook_position, king_position)
        castles[king_position] << [king_position[0], king_position[1] - 2] #king moves -2 cols rook goes to right of king which is -2 + 1
    end

    if board[king_position[0]][7].is_a?(Rook) && !board[king_position[0]][7].moved
      if clear_passage?(rook_position, king_position) && safe_passage?(rook_position, king_position)
        castles[king_position] << [king_position[0], king_position[1] + 2] 
    end
    castles
  end

  #helper function for available_castles
  def safe_passage?(rook_position, king_position)
    min = rook_position[1] < king_position[1] ? king_position[1] - 3 : king_position[1]

    max = rook_position[1] < king_position[1] ? king_position[1] : king_position[1] + 3

    (min + 1).upto(max - 1) do |col| 
      checked = checked_by(player_color, [king_position[0], col])
      return false unless checked.empty? 
    end
    true
  end

  def clear_passage?(rook_position, king_position)
    min, max = min_max(rook_position[1], king_position[1])

    (min + 1).upto(max - 1) do |col|
      return false unless board[king_position[0]][col].nil? 
    end
    true
  end

  def moves_from_check(king_position, king_moves, pieces_that_check) #king moves are also check moves, so get them elsewhere and pass
    #these are:
    # 1. moves the king can make without moving to another checked square
    # 2. moves other pieces can make to capture the checking opponent piece
    # 3. moves other pieces can make to get between the king and the checking piece (if checking piece is not a knight)

    if pieces_that_check.length > 1 #more than one opponent piece responsible for check? we can only move the king
      king_moves
    else
      opponent_position = pieces_that_check[0]

      other_moves = moves_that_take_opponent(opponent_color, opponent_position)

      all_viable_moves = king_moves.merge(other_moves)

      unless board[opponent_position[0]][opponent_position[1]].is_a?(Knight)

        intercepting_moves = moves_that_intercept_opponent(opponent_position, king_position)

        all_viable_moves.merge(intercepting_moves) 
      end

      unless en_passant.nil?
        all_viable_moves.merge(en_passant) if en_passant_rescue?(opponent_position) 
      end
      all_viable_moves
    end
  end

  def checked_by(king_color, position) 
    #checking opponent pieces to see if king position is a valid move for any of them
    #return the posititions of any such pieces
    checking_pieces = []

    board.each_with_index do |row, m| 
      row.each_with_index do |piece, n|

        next if piece.nil? || piece.color == king_color
      
        checks_king = piece.valid_move?(board, [m, n], position)

        checking_pieces << [m, n] if checks_king
      end
    end
    checking_pieces 
  end

  #private 

  def convert_column(char)
    char.ord - 97
  end

  def convert_row(char)
    8 - char.to_i
  end

  def get_king_moves(king_color, king_position)
    moves = get_adjacent_positions(king_position)

    viable_moves = Hash.new { |h, k| h[k] = [] }

    moves.each do |move|
      pieces_that_check = checked_by(king_color, move) 

      viable_moves[king_position] << move if pieces_that_check.empty?
    end

    viable_moves #hash {from king_position] =>  [to1, to2, ... ]}
  end

  def moves_that_take_opponent(opponent_color, opponent_position)
    #if only one opponent piece checks king, possible to get out of check by capturing it
    #returns moves that capture the opponent causing check
    pieces_to_take_checker = checked_by(opponent_color, opponent_position)

    viable_moves = Hash.new { |h, k| h[k] = [] }

    pieces_to_take_checker.each do |piece_position|
      viable_moves[piece_position] << opponent_position
    end
    viable_moves #hash {from piece1: [opponent_position], from piece2: [opponent_position] }
  end

  def moves_that_intercept_opponent(opponent_position, king_position)
    #another possibility is to get out of check by placing a piece between the opponent piece responsible for check and the king
    #only works if the checking piece is not a knight
    opponent_slope = slope(opponent_position[1], opponent_position[0], king_position[1], king_position[0])

    viable_moves = Hash.new { |h, k| h[k] = [] }

    board.each_with_index do |row, m|
      row.each_with_index do |piece, n|

        next if piece.nil? || piece.color == opponent_color || piece.is_a?(King) 

        slopes = piece.slopes 

        slopes.each do |piece_slope| 
          intersection_pt = intersection(opponent_position[1], opponent_position[0], opponent_slope, n, m, piece_slope) 

          viable_moves[[m, n]] << intersection_pt if intercept_occurs_in_range?(opponent_slope, piece_slope, intersection_pt, king_position, opponent_position)
        end
      end
    end
  end

  def en_passant_rescue?(opponent_position)
    position = turn_white ? [opponent_position[0] - 1, opponent_position[1]] : [opponent_position[0] + 1, opponent_position[1]]

    en_passant.has_value?(position)
  end

  def intercept_occurs_in_range?(slope1, slope2, intersection_pt, king, opponent)
    #for a vertical line, we check the Ys
    #for other, check the Xs
    if slope1.nil? || slope2.nil?
      min, max = min_max(king[0], opponent[0])

      intersection_pt[0].between?(min, max)
    else
      min, max = min_max(king[1], opponent[1])

      intersection_pt[1].between?(min, max)
    end
  end

  def min_max(x, y)
    return x, y if x < y
    y, x
end