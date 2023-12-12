require_relative "../lib/pin/pin.rb"

describe Pin do
  subject(:test_pin) { described_class.new(piece: double(color: "white", position: [2, 2]), attacker: double(color: "black", position: [1, 1])) }

  describe "#valid_move?" do
    it "sends valid_move? to pin piece" do
      test_board = double()
      expect(test_pin.piece).to receive(:valid_move?).with({ to: [3, 3], from: [2, 2], board: test_board })
      test_pin.valid_move?(to: [3, 3], from: [2, 2], board: test_board)
    end
  end

  describe "#position" do
    it "sends position to pin piece" do
      expect(test_pin.piece).to receive(:position)
      test_pin.position
    end
  end
end