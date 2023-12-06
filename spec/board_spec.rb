require_relative '../lib/board.rb'

describe Board do
  subject(:test_board) { described_class.new }

  describe "#update" do
    it "updates board position to supplied value" do
      test_board.update(position: [0, 0], value: "updated value")
      expect(test_board.data[0][0]).to eq("updated value")
    end
  end

  describe "#get_piece" do
    it "returns piece at position if piece" do
      test_piece = double
      test_board.update(position: [0, 0], value: test_piece)
      expect(test_board.get_piece([0, 0])).to be(test_piece)
    end

    it "returns nil if no piece at position" do
      expect(test_board.get_piece([0, 0])).to eq(nil)
    end
  end

  describe "#on_board?" do
    it "returns true if position is on board" do
      expect(test_board.on_board?([7, 7])).to be(true)
    end

    it "returns false if position is not on board" do
      expect(test_board.on_board?([-1, -1])).to be (false)
    end
  end
end