require_relative '../lib/moves/move.rb'

describe Move do
  let(:board) { double() }

  describe "#promote?" do
    it "returns true when move piece is promotable and piece moves to last row" do
      test_piece = double(promotable: true, last_row: 7)
      test_move = described_class.new(from: [6, 0], to: [7, 0], piece: test_piece)
      allow(board).to receive(:update)

      expect(test_move.promote?).to be(true)
    end

    it "returns false when move piece is not promotable" do
      test_piece = double(promotable: false, last_row: 7)
      test_move = described_class.new(from: [6, 0], to: [7, 0], piece: test_piece)
      allow(board).to receive(:update)

      expect(test_move.promote?).to be(false)
    end

    it "returns false when move is not to last row" do
      test_piece = double(promotable: true, last_row: 7)
      test_move = described_class.new(from: [6, 0], to: [6, 0], piece: test_piece)
      allow(board).to receive(:update)

      expect(test_move.promote?).to be(false)
    end
  end

  describe "#execute" do
    let(:test_piece) { double(promotable: true, last_row: 7)}
    subject(:test_move) { described_class.new(from: [6, 0], to: [7, 0], piece: test_piece) }

    it "calls board update twice" do
      allow(test_piece).to receive(:position=)
      allow(test_piece).to receive(:moved=)
      expect(board).to receive(:update).with({:position=>[6, 0], :value=>nil})
      expect(board).to receive(:update).with({:position=>[7, 0], :value=>test_piece})
      test_move.execute(board)
    end

    it "calls piece setters" do
      allow(board).to receive(:update)
      expect(test_piece).to receive(:position=).with([7,0])
      expect(test_piece).to receive(:moved=).with(true)
      test_move.execute(board)
    end
  end
end