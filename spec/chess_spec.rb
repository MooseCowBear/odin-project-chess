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
end
