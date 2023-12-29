require_relative '../../lib/pieces/bishop.rb'

describe Bishop do
  subject(:test_bishop) { described_class.new(color: "white", position: [7, 2]) }

  describe '#valid_move?' do
    context "when the move is unobstructed" do
      it "returns true when moving diagonally" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([1, 1]).and_return(nil)
        res = test_bishop.valid_move?(from: [3, 3], to: [1, 1], board: test_board)
        expect(res).to be true
      end

      it "returns false when moving horizontally" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([1, 3]).and_return(nil)
        res = test_bishop.valid_move?(from: [1, 1], to: [1, 3], board: test_board)
        expect(res).to be false
      end

      it "returns false when moving vertically" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([1, 3]).and_return(nil)
        res = test_bishop.valid_move?(from: [3, 3], to: [1, 3], board: test_board)
        expect(res).to be false
      end

      it "returns false when moving at angle other than diagonally" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([1, 2]).and_return(nil)
        res = test_bishop.valid_move?(from: [3, 3], to: [1,21], board: test_board)
        expect(res).to be false
      end
    end

    context "when move is obstructed" do
      it "returns false" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with([4, 4]).and_return(test_teammate)
        res = test_bishop.valid_move?(from: [1, 1], to: [4, 4], board: test_board)
        expect(res).to be false
      end
    end
  end

  describe "#valid_moves" do
    context "when bishop is unobstructed" do
      it "returns only moves that are are on the board" do
        test_board = double
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true, false)
        res = test_bishop.valid_moves(from: [0, 0], board: test_board)
        expect(res.length).to eq(1)
      end
    end

    context "when bishops's moves are obstructed by teammates" do
      it "does not return any moves to squares holding teammates" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_teammate)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_bishop.valid_moves(from: [0, 0], board: test_board)
        expect(res.length).to eq(0)
      end
    end

    context "when bishop's moves are obstructed by opponents" do
      it "includes moves to opponent squares but not beyond" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_opponent)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_bishop.valid_moves(from: [4, 4], board: test_board)
        expect(res.length).to eq(4)
      end
    end
  end
end