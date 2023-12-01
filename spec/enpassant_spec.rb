require_relative '../lib/moves/enpassant.rb'

describe EnPassant do
  let(:board) { double() }
  let(:test_piece) { double() }
  subject(:test_enpassant) { described_class.new(from: [0, 0], to: [1, 1], piece: test_piece, additional_from: [2, 2]) }

  describe "#execute" do
    it "updates the board 3 times" do
      allow(test_piece).to receive(:position=)
      expect(board).to receive(:update).with({ :position => [0, 0], :value => nil })
      expect(board).to receive(:update).with({ :position =>[1, 1], :value => test_piece })
      expect(board).to receive(:update).with({ :position => [2, 2], :value => nil })
      test_enpassant.execute(board)
    end
  end
end