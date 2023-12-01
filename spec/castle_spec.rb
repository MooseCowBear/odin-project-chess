require_relative '../lib/moves/castle.rb'

describe Castle do
  let(:board) { double() }
  let(:test_king) { double() }
  let(:test_rook) { double() }
  subject(:test_castle) { described_class.new(from: [0, 0], to: [1, 1], piece: test_king, additional_from: [2, 2], additional_to: [3, 3], rook: test_rook) }

  describe "#execute" do
    it "updates the board 4 times" do
      allow(test_king).to receive(:position=)
      expect(board).to receive(:update).with({ :position => [0, 0], :value => nil })
      expect(board).to receive(:update).with({ :position =>[1, 1], :value => test_king })
      expect(board).to receive(:update).with({ :position => [2, 2], :value => nil })
      expect(board).to receive(:update).with({ :position => [3, 3], :value => test_rook })
      test_castle.execute(board)
    end
  end
end