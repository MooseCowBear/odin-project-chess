require_relative "../../lib/move_generators/multi_check_move_generator.rb"

describe MultiCheckMoveGenerator do
  subject(:test_generator) { described_class.new(double(), double(), [], double()) }

  describe "#moves" do
    it "calls #king_moves" do
      expect(test_generator).to receive(:king_moves)
      test_generator.king_moves
    end
  end
end