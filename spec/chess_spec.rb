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
end
