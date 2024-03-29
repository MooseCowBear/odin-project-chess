require_relative '../lib/chess.rb'

describe Chess do
  describe "#update_turn" do
    it "sets turn_white instance variable to false if true" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new 
      test_chess.update_turn
      expect(test_chess.white_turn).to be(false)
    end

    it "sets turn_white instance variable to true if false" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_chess.white_turn = false
      test_chess.update_turn
      expect(test_chess.white_turn).to be(true)
    end
  end

  describe "#king" do
    it "returns the white king if white's turn" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      white_king = double()
      black_king = double()
      test_chess.white_king = white_king
      test_chess.black_king = black_king
      expect(test_chess.king).to be(white_king)
    end

    it "returns the black king if black's turn" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      white_king = double()
      black_king = double()
      test_chess.white_king = white_king
      test_chess.black_king = black_king
      test_chess.white_turn = false
      expect(test_chess.king).to be(black_king)
    end
  end

  describe "#current_player" do
    it "returns white player if white turn" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      white_player = double()
      black_player = double()
      test_chess.player_white = white_player
      test_chess.player_black = black_player
      expect(test_chess.current_player).to be(white_player)
    end

    it "returns black player if black turn" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      white_player = double()
      black_player = double()
      test_chess.player_white = white_player
      test_chess.player_black = black_player
      test_chess.white_turn = false
      expect(test_chess.current_player).to be(black_player)
    end
  end

  describe "#check?" do
    it "returns true if checks array not empty" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_chess.checks = [double()]
      expect(test_chess.check?).to be(true)
    end

    it "returns false if checks array empty" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      expect(test_chess.check?).to be(false)
    end
  end

  describe "#checkmate?" do
    it "returns false if available moves" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_chess.moves_available = [double()]
      allow(test_chess).to receive(:check?).and_return(true)
      expect(test_chess.checkmate?).to be(false)
    end

    it "returns false if no checks" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      expect(test_chess.checkmate?).to be(false)
    end

    it "returns true if no available moves and check" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:check?).and_return(true)
      expect(test_chess.checkmate?).to be(true)
    end
  end

  describe "#stalemate?" do
    it "returns false if check" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:check?).and_return(true)
      expect(test_chess.stalemate?).to be(false)
    end

    it "returns false if available moves" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_chess.moves_available = [double()]
      expect(test_chess.stalemate?).to be(false)
    end

    it "returns true if no check and no available moves" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:check?).and_return(false)
      expect(test_chess.stalemate?).to be(true)
    end
  end

  describe "#record_winner" do
    it "records a winner if checkmate" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      white_player = double()
      black_player = double()
      test_chess.player_white = white_player
      test_chess.player_black = black_player
      allow(test_chess).to receive(:checkmate?).and_return(true)
      test_chess.record_winner
      expect(test_chess.winner).to be(black_player)
    end

    it "does not record winner if not checkmate" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      white_player = double()
      black_player = double()
      test_chess.player_white = white_player
      test_chess.player_black = black_player
      allow(test_chess).to receive(:checkmate?).and_return(false)
      test_chess.record_winner
      expect(test_chess.winner).to eq(nil)
    end
  end

  describe "#announce_check" do
    it "announces check if check" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:check?).and_return(true)
      expect(STDOUT).to receive(:puts).with("Check")
      test_chess.announce_check
    end

    it "does not announce check" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:check?).and_return(false)
      expect(STDOUT).not_to receive(:puts)
      test_chess.announce_check
    end
  end

  describe "#announce_result" do
    it "calls annouce ending state and announce winner" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      expect(test_chess).to receive(:announce_ending_state)
      expect(test_chess).to receive(:announce_winner)
      test_chess.announce_result
    end
  end

  describe "#announce_ending_state" do
    it "outputs 'Stalemate' if stalemate" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:stalemate?).and_return(true)
      expect(STDOUT).to receive(:puts).with("Stalemate")
      test_chess.announce_ending_state
    end

    it "outputs 'Checkmate' if not stalemate" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:stalemate?).and_return(false)
      expect(STDOUT).to receive(:puts).with("Checkmate")
      test_chess.announce_ending_state
    end
  end

  describe "#announce_winner" do
    it "congratulates winner if winner" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_winner = double(name: "Bob")
      test_chess.winner = test_winner
      expect(STDOUT).to receive(:puts).with("Congratulations, #{test_winner.name}!")
      test_chess.announce_winner
    end

    it "announces draw if no winner" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      expect(STDOUT).to receive(:puts).with("It's a draw.")
      test_chess.announce_winner
    end
  end

  describe "#make_move" do
    it "asks move to execute and adds move to moves taken array " do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_move = double()
      expect(test_move).to receive(:execute)
      test_chess.make_move(test_move)
      expect(test_chess.moves_taken.include?(test_move)).to be(true)
    end
  end

  describe "#announce_move" do
    it "prints player and move to console" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_player = double(name: "Harry")
      allow(test_chess).to receive(:current_player).and_return(test_player)
      test_move = double()
      allow(test_move).to receive(:to_s).and_return("test move")
      expect(STDOUT).to receive(:puts).with("#{test_player.name} moved test move.")
      test_chess.announce_move(test_move)
    end
  end

  describe "#perform_promotion" do
    it "asks promoter to promote" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_promoter = double()
      expect(test_promoter).to receive(:promote)
      test_chess.perform_promotion(test_promoter)
    end
  end

  describe "#legal?" do
    it "returns true if move is in available moves" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_move = double()
      test_chess.moves_available << test_move
      expect(test_chess.legal?(test_move)).to be(true)
    end

    it "returns false if move not in available moves" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_move = double()
      expect(test_chess.legal?(test_move)).to be(false)
    end
  end

  describe "#update_available_moves" do
    it "asks move generator for moves" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_generator = double()
      expect(test_generator).to receive(:moves)
      test_chess.update_available_moves(test_generator)
    end
  end

  describe "#update_checks" do
    it "asks board for closest neighbors and calls checks for squares on opponents" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_board = double()
      test_king = double(position: [0, 0], color: "white")
      test_chess.white_king = test_king
      test_chess.board = test_board 
      expect(test_board).to receive(:closest_neighbors)
      expect(test_chess).to receive(:checks_for_square)
      test_chess.update_checks
    end

    it "updates checks with the result" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_board = double()
      test_king = double(position: [0, 0], color: "white")
      test_chess.white_king = test_king
      test_chess.board = test_board 
      allow(test_board).to receive(:closest_neighbors)
      allow(test_chess).to receive(:checks_for_square).and_return([double()])
      test_chess.update_checks
      expect(test_chess.checks.length).to eq(1)
    end
  end

  describe "#get_player_move" do
    it "asks player for move until legal move is provided" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_player = double(name: "Sally")
      allow(test_chess).to receive(:current_player).and_return(test_player)
      allow(test_player).to receive(:move)
      allow(test_chess).to receive(:legal?).and_return(false, true)
      expect(STDOUT).to receive(:puts).with("Enter a move for #{test_player.name}.").twice
      expect(STDOUT).to receive(:puts).with("I'm sorry, that was not a legal move.").once
      test_chess.get_player_move
    end

    it "returns move" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_player = double(name: "Sally")
      allow(test_chess).to receive(:current_player).and_return(test_player)
      test_move = double()
      allow(test_player).to receive(:move).and_return(test_move)
      allow(test_chess).to receive(:legal?).and_return(true)
      allow(STDOUT).to receive(:puts)
      expect(test_chess.get_player_move).to be(test_move)
    end
  end

  describe "#take_turn" do
    it "calls each method that makes up a turn" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      expect(test_chess).to receive(:announce_check)
      expect(test_chess).to receive(:get_player_move)
      expect(test_chess).to receive(:make_move)
      expect(test_chess).to receive(:announce_move)
      expect(test_chess).to receive(:perform_promotion)
      expect(test_chess).to receive(:update_turn)
      expect(test_chess).to receive(:update_checks)
      expect(test_chess).to receive(:update_available_moves)
      test_chess.take_turn
    end
  end

  describe "#display_turns" do
    it "calls take_turn for as long as not checkmate" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:checkmate?).and_return(false, false, true)
      allow(test_chess).to receive(:stalemate?).and_return(false)
      allow(Chess).to receive(:ask_to_save)
      expect(test_chess).to receive(:take_turn).twice
      test_chess.display_turns
    end

    it "calls taks_turn for as long as not stalemate" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:checkmate?).and_return(false)
      allow(test_chess).to receive(:stalemate?).and_return(false, false, false, true)
      allow(Chess).to receive(:ask_to_save)
      expect(test_chess).to receive(:take_turn).exactly(3).times
      test_chess.display_turns
    end

    it "asks to save game after every turn" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      allow(test_chess).to receive(:checkmate?).and_return(false)
      allow(test_chess).to receive(:stalemate?).and_return(false, false, true)
      allow(test_chess).to receive(:take_turn)
      expect(Chess).to receive(:ask_to_save).twice
      test_chess.display_turns
    end
  end

  describe "#print_board" do
    it "asks board to print" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_board = double()
      test_chess.board = test_board
      allow(STDOUT).to receive(:puts)
      expect(test_board).to receive(:print)
      test_chess.print_board("current")
    end

    it "announces board state" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      test_board = double()
      test_chess.board = test_board
      allow(test_board).to receive(:print)
      expect(STDOUT).to receive(:puts).with("\nThe current board is: \n")
      test_chess.print_board("current")
    end
  end

  describe "#play_game" do
    it "calls each method that makes up playing a game" do
      allow_any_instance_of(Chess).to receive(:setup)
      test_chess = described_class.new
      expect(test_chess).to receive(:print_board).with("current")
      expect(test_chess).to receive(:display_turns)
      expect(test_chess).to receive(:record_winner)
      expect(test_chess).to receive(:announce_result)
      expect(test_chess).to receive(:print_board).with("final")
      expect(Chess).to receive(:save_game)
      test_chess.play_game
    end
  end

  describe ".get_game_choice" do
    it "asks for game choice until valid choice is made" do
      allow(Chess).to receive(:display_game_choices)
      allow(STDIN).to receive(:gets).and_return("8", "1")
      allow(Chess).to receive(:validate_choice).and_return(false, true)
      expect(STDOUT).to receive(:puts).with("Enter the number of the game you would like to load.").twice
      Chess.get_game_choice([double(), double()])
    end

    it "returns the chosen game" do
      allow(Chess).to receive(:display_game_choices)
      allow(STDIN).to receive(:gets).and_return("1")
      allow(Chess).to receive(:validate_choice).and_return(true)
      expect(STDOUT).to receive(:puts).with("Enter the number of the game you would like to load.")
      test_game = double()
      expect(Chess.get_game_choice([test_game])).to be(test_game)
    end
  end

  describe ".load_game?" do
    it "returns false if no games to load" do
      test_games = []
      expect(Chess.load_game?(test_games)).to be(false)
    end

    it "returns false if user inputs 'n' or 'no'" do
      test_games = [double()]
      allow(STDOUT).to receive(:puts)
      allow(STDIN).to receive(:gets).and_return("no")
      expect(Chess.load_game?(test_games)).to be(false)
    end

    it "returns true if user inputs 'y' or 'yes'" do
      test_games = [double()]
      allow(STDOUT).to receive(:puts)
      allow(STDIN).to receive(:gets).and_return("y")
      expect(Chess.load_game?(test_games)).to be(true)
    end

    it "asks for choice until user inputs yes or no" do
      test_games = [double()]
      allow(STDIN).to receive(:gets).and_return("blah", "yes")
      expect(STDOUT).to receive(:puts).with("Would you like to load a saved game? (y/n)").twice
      expect(STDOUT).to receive(:puts).with("Answer must be yes or no.")
      Chess.load_game?(test_games)
    end
  end

  describe ".play" do
    it "loads unfinished games" do
      allow(Chess).to receive(:load_game?).and_return(true)
      test_game = double()
      allow(Chess).to receive(:get_game_choice).and_return(test_game)
      allow(test_game).to receive(:play_game)
      expect(Chess).to receive(:unfinished_games)
      Chess.play
    end

    it "loads game to play if load game" do
      allow(Chess).to receive(:unfinished_games)
      allow(Chess).to receive(:load_game?).and_return(true)
      test_game = double()
      allow(Chess).to receive(:get_game_choice).and_return(test_game)
      expect(test_game).to receive(:play_game)
      Chess.play
    end

    it "creates a new game to play if not load game" do
      allow(Chess).to receive(:unfinished_games)
      allow(Chess).to receive(:load_game?).and_return(false)
      test_game = double()
      expect(Chess).to receive(:new).and_return(test_game)
      expect(test_game).to receive(:play_game)
      Chess.play
    end
  end
end
