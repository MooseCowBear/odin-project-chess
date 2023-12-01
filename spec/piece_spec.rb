require_relative "../lib/pieces/piece.rb"

describe Piece do
  describe "#teammate?" do
    subject(:test_piece) { described_class.new(color: "white", position: [0, 0]) }

    it "returns true of colors match" do
      expect(test_piece.teammate?("white")).to be(true)
    end

    it "returns false if colors don't match" do
      expect(test_piece.teammate?("black")).to be(false)
    end
  end

  describe "#opponent?" do
    subject(:test_piece) { described_class.new(color: "white", position: [0, 0]) }

    it "returns false is colors match" do
      expect(test_piece.opponent?("white")).to be(false)
    end

    it "returns true if colors don't match" do
      expect(test_piece.opponent?("black")).to be(true)
    end
  end

  describe "#white?" do
    it "returns true if piece color is white" do
      white_piece = described_class.new(color: "white", position: [0, 0]) 
      expect(white_piece.white?).to be(true)
    end

    it "returns false if piece color is black" do
      black_piece = described_class.new(color: "black", position: [0, 0])
      expect(black_piece.white?).to be(false)
    end
  end

  describe "#last_row" do
    it "returns 7 if piece is black" do
      black_piece = described_class.new(color: "black", position: [0, 0])
      expect(black_piece.last_row).to eq(7)
    end

    it "returns 0 if piece is white" do
      white_piece = described_class.new(color: "white", position: [0, 0]) 
      expect(white_piece.last_row).to eq(0)
    end
  end
end