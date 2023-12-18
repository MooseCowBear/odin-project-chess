require_relative "./modules/square_checker"
require_relative "./modules/setup"
require_relative "./modules/serialize"


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
end