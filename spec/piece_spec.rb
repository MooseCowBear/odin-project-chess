require_relative "../lib/pieces/piece.rb"

describe Piece do
  describe "#teammate?" do
    subject(:test_piece) { described_class.new(color: "white", position: [0, 0], promotable: false) }

    it "returns true of colors match" do
      test_teammate = double(color: "white")
      expect(test_piece.teammate?(test_teammate)).to be(true)
    end

    it "returns false if colors don't match" do
      test_opponent = double(color: "black")
      expect(test_piece.teammate?(test_opponent)).to be(false)
    end
  end

  describe "#opponent?" do
    subject(:test_piece) { described_class.new(color: "white", position: [0, 0], promotable: false) }

    it "returns false is colors match" do
      test_teammate = double(color: "white")
      expect(test_piece.opponent?(test_teammate)).to be(false)
    end

    it "returns true if colors don't match" do
      test_opponent = double(color: "black")
      expect(test_piece.opponent?(test_opponent)).to be(true)
    end
  end

  describe "#white?" do
    it "returns true if piece color is white" do
      white_piece = described_class.new(color: "white", position: [0, 0], promotable: false) 
      expect(white_piece.white?).to be(true)
    end

    it "returns false if piece color is black" do
      black_piece = described_class.new(color: "black", position: [0, 0], promotable: false)
      expect(black_piece.white?).to be(false)
    end
  end

  describe "#last_row" do
    it "returns 7 if piece is black" do
      black_piece = described_class.new(color: "black", position: [0, 0], promotable: false)
      expect(black_piece.last_row).to eq(7)
    end

    it "returns 0 if piece is white" do
      white_piece = described_class.new(color: "white", position: [0, 0], promotable: false) 
      expect(white_piece.last_row).to eq(0)
    end
  end

  describe "methods that should be implemented by subclasses" do 
    subject(:test_piece) { described_class.new(color: "white", position: [0, 0], promotable: false) }

    describe "#to_s" do
      it "raises exception" do
        msg = "This method needs to be defined in the subclass"
        expect { test_piece.to_s }.to raise_error(msg)
      end
    end

    describe "#valid_move?" do
      it "raises exception" do
        msg = "This method needs to be defined in the subclass"
        expect { test_piece.valid_move?(to: [0, 0], from: [1, 1], board: nil) }.to raise_error(msg)
      end
    end

    describe "#valid_moves" do
      it "raises exception" do
        msg = "This method needs to be defined in the subclass"
        expect { test_piece.valid_moves(from: [0, 0], board: nil) }.to raise_error(msg)
      end
    end
  end
end