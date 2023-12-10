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

  describe "#under_attack?" do
    it "returns true if opponent piece can attack from square" do
      test_opponent = double(color: "white")
      test_board.update(position: [0, 0], value: test_opponent)
      allow(test_opponent).to receive(:opponent?).with(anything).and_return(true)
      allow(test_opponent).to receive(:valid_move?).with(anything).and_return(true)
      expect(test_board.under_attack?(from: [0, 0], to: [1, 1], alliance: double(color:"black"))).to be(true)
    end

    it "returns false if teammate piece on from square" do
      test_teammate = double(color: "white")
      test_board.update(position: [0, 0], value: test_teammate)
      allow(test_teammate).to receive(:opponent?).with(anything).and_return(false)
      allow(test_teammate).to receive(:valid_move?).with(anything).and_return(true)
      expect(test_board.under_attack?(from: [0, 0], to: [1, 1], alliance: double(color: "white"))).to be(false)
    end

    it "returns false if opponent piece cannot attack from square" do
      test_opponent = double(color: "white")
      test_board.update(position: [0, 0], value: test_opponent)
      allow(test_opponent).to receive(:opponent?).with(anything).and_return(true)
      allow(test_opponent).to receive(:valid_move?).with(anything).and_return(false)
      expect(test_board.under_attack?(from: [0, 0], to: [1, 1], alliance: double(color:"black"))).to be(false)
    end

    it "returns false if from square is empty" do
      test_board.update(position: [0, 0], value: nil)
      expect(test_board.under_attack?(from: [0, 0], to: [1, 1], alliance: double(color:"black"))).to be(false)
    end
  end

  describe "#column_neighbor" do
    it "returns piece in adjacent column if there is one" do
      test_piece = double(color: "white")
      test_board.update(position: [1, 2], value: test_piece)
      expect(test_board.column_neighbor(move: double(to: [1, 1]), direction: 1)).to be(test_piece)
    end

    it "returns nil if there are no piece in adjacent column and column is on board" do
      expect(test_board.column_neighbor(move: double(to: [1, 1]), direction: 1)).to eq(nil)
    end

    it "returns nil if column is not on board" do
      expect(test_board.column_neighbor(move: double(to: [1, 0]), direction: -1)).to eq(nil)
    end
  end

  describe "#column_neighbors" do
    it "returns an array of length 1 when there is one column neighbor" do
      test_piece = double(color: "white")
      test_board.update(position: [1, 2], value: test_piece)
      res = test_board.column_neighbors(move: double(to: [1, 1]))
      expect(res.length).to be(1)
      expect(res.first).to be(test_piece)
    end

    it "returns an array of length 2 when there are two column neighbors" do
      test_neighbor_one = double(color: "white")
      test_neighbor_two = double(color: "black")
      test_board.update(position: [1, 4], value: test_neighbor_one)
      test_board.update(position: [1, 2], value: test_neighbor_two)
      res = test_board.column_neighbors(move: double(to: [1, 3]))
      expect(res.length).to be(2)
      expect(res.include?(test_neighbor_one)).to be(true)
      expect(res.include?(test_neighbor_two)).to be(true)
    end

    it "returns an empty array if there are no column neighbors" do
      res = test_board.column_neighbors(move: double(to: [1, 3]))
      expect(res.empty?).to be(true)
    end
  end
end