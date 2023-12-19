require_relative "./modules/square_checker"
require_relative "./modules/setup"
require_relative "./modules/serialize"
require_relative "./pawn_promoter"
require_relative "./move_generators/move_generator"


class Chess
  include SquareChecker
  include Setup
  extend Serialize 

  attr_reader :played_on
  attr_accessor :white_king, :black_king, :player_white, :player_black, :white_turn, :board, :moves_available, :moves_taken, :winner, :checks

  def initialize
    @played_on = Time.now
    @white_turn = true 
    @moves_available = []
    @moves_taken = [] 
    @winner = nil 
    @checks = [] 

    setup
  end

  def stalemate?
    moves_available.empty? && !check?
  end

  def checkmate?
    moves_available.empty? && check?
  end

  def check? 
    !checks.empty?
  end

  def update_turn
    @white_turn = !white_turn
  end

  def king 
    white_turn ? white_king : black_king
  end

  def current_player 
    white_turn ? player_white : player_black
  end

  def record_winner
    if checkmate?
      @winner = white_turn ? player_black : player_white
    end
  end

  def announce_check
    puts "Check" if check?
  end

  def announce_result
    announce_ending_state
    announce_winner
  end

  def announce_ending_state
    if stalemate?
      puts "Stalemate"
    else
      puts "Checkmate"
    end
  end

  def announce_winner
    unless winner.nil?
      puts "Congratulations, #{winner.name}!"
    else 
      puts "It's a draw."
    end
  end

  def make_move(move)
    move.execute(board)
    @moves_taken << move
  end

  def announce_move(move) 
    puts "#{current_player.name} moved #{move}."
  end

  def perform_promotion(promoter)
    promoter.promote
  end

  def legal?(move) 
    moves_available.include?(move)
  end

  def update_available_moves(move_generator)
    @moves_available = move_generator.moves
  end

  def update_checks
    opponents, _ = board.closest_neighbors(square: king.position, alliance: king) 
    @checks = checks_for_square(
      board: board, 
      square: king.position, 
      opponents: opponents, 
      alliance: king
    )
  end

  def get_player_move
    loop do 
      puts "Enter a move for #{current_player.name}."
      move = current_player.move(moves_available)
      return move if legal?(move)
      puts "I'm sorry, that was not a legal move."
    end
  end

  def take_turn
    announce_check
    move = get_player_move
    make_move(move)
    announce_move(move)
    perform_promotion(PawnPromoter.new(move, board, current_player))
    update_turn
    update_checks
    update_available_moves(
      MoveGenerator.for(
        king: king, 
        board: board, 
        checks: checks, 
        last_move: moves_taken.last
      )
    )
  end
end