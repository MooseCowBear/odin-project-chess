require_relative './euclid.rb' #need for intersection methods
require_relative './king.rb'
require_relative './queen.rb'
require_relative './bishop.rb'
require_relative './knight.rb'
require_relative './rook.rb'
require_relative './pawn.rb'

class Chess
  include Euclid

  def initialize
    @player_white = nil #get player names at the start of play
    @player_black = nil
    @board = get_starting_board #right now its a new game board
    #@white_pieces = get_starting_pieces(white) #sets of pieces on the board and adds to relevant collection - used to check for check, checkmate
    #@black_pieces = get_starting_pieces(black)  #so we don't have to loop the whole board when there are few pieces
    @turn_white = true
    @white_king_position = nil 
    @black_king_position = nil 

    @num_moves = 0
    @en_passant = [] #empty array if not an option. [start, end] if option
    @check_white = false
    @check_black = false
    @history = get_history
  end

  def play
  end

  def get_starting_board
    Array.new(8) { Array.new(8) } #later, update to read in board from file

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
  end

  def get_history #later update to read from file
    Hash.new
  end

  def get_move
  end

  def convert_move(move)
    #need to convert inputs like a4b2 to pairs of matrix indices
    move = move.downcase 
    #letter is column, number is row
    start_col = 97 - move[0].ord
    start_row = 8 - move[1].to_i
    end_col = 97 - move[2].ord
    end_row = 8 - move[3].to_i
    return [[start_row, start_col], [end_row, end_col]]
  end

  def on_board?(move) #this means we don't need to check if on board elsewhere!!
    return false unless move.length == 4
    return false unless move.downcase[0].between?('a', 'h') && move[2].downcase.between?('a', 'h')
    return false unless move[1].to_i.between?(1, 8) && move[3].to_i.between?(1, 8)
    true
  end

  def print_board
    pp board #change later
  end

  #need to have functions that test the waters for case when moving a piece out of its position might put player in check
  def make_move(start_pt, end_pt)
    
  end

  def revert_move(start_pt, end_pt) 
    make_move(end_pt, start_pt)
  end


  def moves_out_of_check(king_color, king_position, pieces_that_check)
    #these are 1. moves the king can make without moving to another checked square
    # 2. moves other pieces can make to "take" the checking opponent piece
    # 3. moves other pieces can make to get between the king and the checking piece (if checking piece is not a knight)

  end

  def checked_by(king_color, king_position)
    #loops board, checking opponent pieces to see if king position is a valid move for any of them
    pieces_that_check = []
    board.each_with_index do |row, m| 
      row.each_with_index do |piece, n|
        next if piece.nil? || piece.color == king_color
        #for opponent piece
        checks_king = piece.valid_move?(board, [m, n], king_position)
        pieces_that_check << [m, n]
      end
    end
    pieces_that_check #holds positions of pieces that check
  end

  def check?(pieces_that_check)
    return false if pieces_that_check.empty?
    true
  end

  def checkmate?(possible_moves)
    possible_moves.empty? 
  end

  private 

  def king_moves_from_check(king_color, king_position)
    moves = get_adjacent_positions(king_position)
    viable_moves = Hash.new { |h, k| h[k] = [] }
    moves.each do |move|
      pieces_that_check = checked_by(king_color, move) #check that each move the king can make to see if it is safe
      viable_moves[king_position] << move if pieces_that_check.empty?
    end
    viable_moves #hash like [from]: [to1, to2, ... ]
  end

  def moves_that_take_opponent(opponent_color, opponent_position)
    #if only on opponent piece checks king, possible to get out of check by eating it
    #so now looking for own pieces that "check" that opponent pieces!
    pieces_to_take_checker = checked_by(opponent_color, opponent_position)
    viable_moves = Hash.new { |h, k| h[k] = [] }
    pieces_to_take_checker.each do |piece_position|
      viable_moves[piece_position] << opponent_position
    end
    viable_moves #hash like [from]: [to1, to2, ... ]
  end

  #only matters if there is a SINGLE opponent piece producing the check
  def moves_that_intercept_opponent(opponent_color, opponent_position, king_position)
    opponent_slope =  slope(opponent_position[1], opponent_position[0], king_position[1], king_position[0])
    viable_moves = Hash.new { |h, k| h[k] = [] }

    board.each_with_index do |row, m|
      row.each_with_index do |piece, n|
        next if piece.nil? || piece.color == opponent_color || piece.is_a?(King) #only checking for moves kings teammates can make
        slopes = piece.slopes #all non-king pieces have a slopes property
        slopes.each do |piece_slope| #slopes updated to have both postive and negative
          intersection_pt = intersection(opponent_position[1], opponent_position[0], opponent_slope, n, m, piece_slope)  #[y, x] ie. [row, col]
          viable_moves[[m, n]] << intersection_pt if intercept_occurs_in_range?(opponent_slope, piece_slope, intersection_pt, king_position, opponent_position)
        end
      end
    end
  end

  def intercept_occurs_in_range?(slope1, slope2, intersection_pt, king_position, opponent_position)
    if slope1.nil? || slope2.nil?
      #if one is a vertical line, check to see if the Y of the intersection is between Ys of king and opponent piece
      min = king_position[0] < opponent_position[0] ? king_position[0] : opponent_position[0]
      max = king_position[0] < opponent_position[0] ? opponent_position[0] : king_position[0]
      intersection_pt[0].between?(min, max)
    else
      #else, check X of intersection if between Xs of king and opponent
      min = king_position[1] < opponent_position[1] ? king_position[1] : opponent_position[1]
      max = king_position[1] < opponent_position[1] ? opponent_position[1] : king_position[1]
      intersection_pt[1].between?(min, max)
    end
  end
end