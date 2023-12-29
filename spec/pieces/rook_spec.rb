require_relative '../../lib/pieces/rook.rb'

describe Rook do
  subject(:test_rook) { described_class.new(color: "white", position: [7, 0]) }

  describe '#valid_move?' do
    context "when moving horizontally" do
      it "returns true moving left unobstructed" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([0, 3]).and_return(nil)
        res = test_rook.valid_move?(from: [0, 1], to: [0, 3], board: test_board)
        expect(res).to be true
      end

      it "returns true moving right unobstructed" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([0, 1]).and_return(nil)
        res = test_rook.valid_move?(from: [0, 3], to: [0, 1], board: test_board)
        expect(res).to be true
      end

      it "returns false if obstructed" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with([0, 1]).and_return(test_teammate)
        res = test_rook.valid_move?(from: [0, 3], to: [0, 1], board: test_board)
        expect(res).to be false
      end
    end

    context "when moving vertically" do
      it "returns true moving from higher indexed row to lower" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([1, 0]).and_return(nil)
        res = test_rook.valid_move?(from: [3, 0], to: [1, 0], board: test_board)
        expect(res).to be true
      end

      it "returns true moving from lower indexed row to higher" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([3, 0]).and_return(nil)
        res = test_rook.valid_move?(from: [1, 0], to: [3, 0], board: test_board)
        expect(res).to be true
      end
    end

    context "when moving at angle other than horizontally" do
      it "returns false" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([3, 3]).and_return(nil)
        res = test_rook.valid_move?(from: [1, 1], to: [3, 3], board: test_board)
        expect(res).to be false
      end
    end
  end

  describe "#valid_moves" do
    context "when rook is unobstructed" do
      it "returns only moves that are are on the board" do
        test_board = double
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true, false)
        res = test_rook.valid_moves(from: [0, 0], board: test_board)
        expect(res.length).to eq(1)
      end
    end

    context "when rook is obstructed by teammates" do
      it "does not return any moves to squares holding teammates" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_teammate)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_rook.valid_moves(from: [0, 0], board: test_board)
        expect(res.length).to eq(0)
      end
    end

    context "when rook is obstructed by opponents" do
      it "includes moves to opponent squares but not beyond" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_opponent)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_rook.valid_moves(from: [4, 4], board: test_board)
        expect(res.length).to eq(4)
      end
    end
  end
end