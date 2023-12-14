require_relative "../lib/move_generators/single_check_move_generator.rb"
require_relative "../lib/moves/move"

describe SingleCheckMoveGenerator do

  describe "#moves" do
    it "calls #king_moves and defender moves" do
      test_generator = described_class.new(double(), double(), [], double())
      allow(test_generator).to receive(:king_moves).and_return([])
      allow(test_generator).to receive(:defender_moves).and_return([])

      expect(test_generator).to receive(:king_moves)
      expect(test_generator).to receive(:defender_moves)
      test_generator.moves
    end
  end

  describe "#defender_moves" do
    it "includes enpassant move when it captures checking piece" do
      test_check = double(position: [1, 1])
      test_generator = described_class.new(double(), double(), [test_check], double())
      allow(test_generator.board).to receive(:closest_neighbors).and_return([[], []])
      ep = double()
      allow(test_generator).to receive(:get_enpassant).and_return([ep])
      allow(ep).to receive(:captures).and_return(test_generator.checks.first)

      res = test_generator.defender_moves
      expect(res.length).to eq(1)
      expect(res.first).to be(ep)
    end

    it "excludes enpassant moves when they do not capture checking piece" do
      test_check = double(position: [1, 1])
      test_generator = described_class.new(double(), double(), [test_check], double())
      allow(test_generator.board).to receive(:closest_neighbors).and_return([[], []])
      ep = double()
      allow(test_generator).to receive(:get_enpassant).and_return([ep])
      allow(ep).to receive(:captures).and_return(nil)

      res = test_generator.defender_moves
      expect(res.length).to eq(0)
    end

    it "includes a move for every teammate that can capture checking piece" do
      test_check = double(position: [1, 1])
      test_generator = described_class.new(double(), double(), [test_check], double())
      teammate_one = double(position: [0, 1])
      teammate_two = double(position: [0, 0])
      allow(test_generator.board).to receive(:closest_neighbors).and_return([[teammate_one, teammate_two], []])
      allow(teammate_one).to receive(:valid_move?).and_return(true)
      allow(teammate_two).to receive(:valid_move?).and_return(true)
      allow(Move).to receive(:new).and_return(double("move"))
      allow(test_generator).to receive(:get_enpassant).and_return([])

      res = test_generator.defender_moves
      expect(res.length).to eq(2)
    end

    it "does not include a move for teammates that cannot capture checking piece" do
      test_check = double(position: [1, 1])
      test_generator = described_class.new(double(), double(), [test_check], double())
      teammate_one = double(position: [0, 1])
      teammate_two = double(position: [0, 0])
      allow(test_generator.board).to receive(:closest_neighbors).and_return([[teammate_one, teammate_two], []])
      allow(teammate_one).to receive(:valid_move?).and_return(true)
      allow(teammate_two).to receive(:valid_move?).and_return(false)
      allow(Move).to receive(:new).and_return(double("move"))
      allow(test_generator).to receive(:get_enpassant).and_return([])

      res = test_generator.defender_moves
      expect(res.length).to eq(1)
    end
  end
end