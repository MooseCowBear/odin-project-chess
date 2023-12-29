require_relative "../../lib/modules/square_checker.rb"

describe SquareChecker do 
  let(:dummy_class) { Class.new { extend SquareChecker } }
  let(:test_board) { double } 
  let(:ally) { double(color: "white") }

  describe "#knight_checks" do
    it "returns the correct number of attacking knights" do
      allow(test_board).to receive(:under_attack?).with(anything).and_return(true)
      allow(test_board).to receive(:get_piece).with(anything).and_return(double(color: "black"))

      expect(dummy_class.knight_checks(square: [3, 3], board: test_board, alliance: ally).length).to eq(8)
    end

    it "returns the pieces capable of attacking square" do
      test_opponent = double(color: "black")
      allow(test_board).to receive(:under_attack?).with(anything).and_return(true)
      allow(test_board).to receive(:get_piece).with(anything).and_return(test_opponent)

      res = dummy_class.knight_checks(square: [3, 3], board: test_board, alliance: ally)
      expect(res.all? { |elem| elem == test_opponent }).to be(true)
    end
  end

  describe "#non_knight_checks" do
    it "returns the correct number of opponent checks" do
      test_opponents = [double(color: "black", position: [1, 1]), double(color: "black", position: [3, 3]), double(color: "black", position: [4, 4])]
      allow(test_board).to receive(:under_attack?).with(anything).and_return(true, true, false)

      res = dummy_class.non_knight_checks(square: [2, 2], board: test_board, opponents: test_opponents, alliance: ally)
      expect(res.length).to eq(2)
    end

    it "returns the opponent pieces that are checking square" do
      test_opponents = [double(color: "black", position: [1, 1]), double(color: "black", position: [3, 3]), double(color: "black", position: [4, 4])]
      allow(test_board).to receive(:under_attack?).with(anything).and_return(true, true, false)

      res = dummy_class.non_knight_checks(square: [2, 2], board: test_board, opponents: test_opponents, alliance: ally)
      expect(res.include?(test_opponents[0])).to be(true)
      expect(res.include?(test_opponents[1])).to be(true)
      expect(res.include?(test_opponents[2])).to be(false)
    end
  end

  describe "#checks_for_square" do
    it "combines results of knight and non-knight checks" do
      allow(dummy_class).to receive(:non_knight_checks).with(anything).and_return(["one", "two"])
      allow(dummy_class).to receive(:knight_checks).with(anything).and_return(["three"])

      res = dummy_class.checks_for_square(board: test_board, square: [0, 0], opponents: [], alliance: ally)
      expect(res.length).to eq(3)
      expect(res.include?("one")).to be(true)
      expect(res.include?("two")).to be(true)
      expect(res.include?("three")).to be(true)
    end
  end

  describe "#unchecked_square?" do
    it "returns true if no checks for square" do
      allow(test_board).to receive(:closest_neighbors).with(anything).and_return([[], []])
      allow(dummy_class).to receive(:checks_for_square).with(anything).and_return([])

      res = dummy_class.unchecked_square?(square: [0, 0], board: test_board, alliance: ally)
      expect(res).to be(true)
    end

    it "returns false if at least one check for square" do
      allow(test_board).to receive(:closest_neighbors).with(anything).and_return([[], []])
      allow(dummy_class).to receive(:checks_for_square).with(anything).and_return(["a check"])

      res = dummy_class.unchecked_square?(square: [0, 0], board: test_board, alliance: ally)
      expect(res).to be(false)
    end
  end
end