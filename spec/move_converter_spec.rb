require_relative "../lib/move_converter" 

describe MoveConverter do
  subject(:test_converter) { described_class.new } 

  describe "#convert" do
    it "returns nil if the input is not of length 4" do
      expect(test_converter.convert("somethingbad", [])).to eq(nil)
    end

    it "returns nil if the input does not match a move in moves" do
      expect(test_converter.convert("a4b2", [])).to eq(nil)
    end

    it "returns the move in moves whose to property matches start_idx and whose from property matches end_idx" do
      test_moves = double()
      test_move = double()
      allow(test_moves).to receive(:select).and_return([test_move])

      expect(test_converter.convert("a2c6", test_moves)).to be(test_move)
    end
  end

  describe "#start_idx" do
    it "returns the first and second characters converted" do
      expect(test_converter.start_idx("a2c6")).to eq([6, 0])
    end
  end

  describe "#end_idx" do
    it "returns the third and fourth characters converted" do
      expect(test_converter.end_idx("a2c6")).to eq([2, 2])
    end
  end

  describe "#convert_column" do
    it "it maps A to 0" do
      expect(test_converter.convert_column("A")).to eq(0)
    end

    it "it maps a to 0" do
      expect(test_converter.convert_column("a")).to eq(0)
    end

    it "maps H to 7" do
      expect(test_converter.convert_column("H")).to eq(7)
    end

    it "maps h to 7" do
      expect(test_converter.convert_column("h")).to eq(7)
    end
  end

  describe "#convert_row" do
    it "maps '1' to 7" do
      expect(test_converter.convert_row("1")).to eq(7)
    end

    it "maps '8' to 0" do
      expect(test_converter.convert_row("8")).to eq(0)
    end
  end
end