require_relative '../../lib/pieces/queen.rb'

describe Queen do
  subject(:test_queen) { described_class.new(color: "white", position: [7, 3], promotable: false) } 

  describe '#valid_move?' do
    context "when the move is unobstructed" do
      it "returns true when queen is moving horizontally" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([1, 3]).and_return(nil)
        res = test_queen.valid_move?(from: [1, 1], to: [1, 3], board: test_board)
        expect(res).to be true
      end

      it "returns true when moving vertically" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([3, 1]).and_return(nil)
        res = test_queen.valid_move?(from: [1, 1], to: [3, 1], board: test_board)
        expect(res).to be true
      end

      it "returns true when moving diagonally" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([3, 3]).and_return(nil)
        res = test_queen.valid_move?(from: [1, 1], to: [3, 3], board: test_board)
        expect(res).to be true
      end

      it "returns false when moving on an angle other than diagonally" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([2, 4]).and_return(nil)
        res = test_queen.valid_move?(from: [1, 1], to: [2, 4], board: test_board)
        expect(res).to be false
      end
    end

    context "when move is obstructed" do
      it "it returns false" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with([4, 4]).and_return(test_teammate)
        res = test_queen.valid_move?(from: [1, 1], to: [4, 4], board: test_board)
        expect(res).to be false
      end
    end
  end

  describe "#valid_moves" do
    context "when queen is unobstructed" do
      it "returns only moves that are are on the board" do
        test_board = double
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true, false)
        res = test_queen.valid_moves(from: [0, 0], board: test_board)
        expect(res.length).to eq(1)
      end
    end

    context "when queen's moves are obstructed by teammates" do
      it "does not return any moves to squares holding teammates" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_teammate)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_queen.valid_moves(from: [0, 0], board: test_board)
        expect(res.length).to eq(0)
      end
    end

    context "when queen's moves are obstructed by opponents" do
      it "includes moves to opponent squares but not beyond" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_opponent)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_queen.valid_moves(from: [4, 4], board: test_board)
        expect(res.length).to eq(8)
      end
    end
  end
end