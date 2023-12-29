require_relative '../../lib/pieces/knight.rb'

describe Knight do
  subject(:test_knight) { described_class.new(color: "white", position: [7, 1]) }

  describe '#valid_move?' do
    context "when trying to move according to knight rules" do
      it "returns true when moving to empty square" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([1, 2]).and_return(nil)
        res = test_knight.valid_move?(from: [0, 0], to: [1, 2], board: test_board)
        expect(res).to be true
      end

      it "returns true when moving to square containing opponent" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:get_piece).with([0, 0]).and_return(test_opponent)
        res = test_knight.valid_move?(from: [2, 1], to: [0, 0], board: test_board)
        expect(res).to be true
      end

      it "returns false when moving to square containging teammate" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with([1, 2]).and_return(test_teammate)
        res = test_knight.valid_move?(from: [0, 0], to: [1, 2], board: test_board)
        expect(res).to be false
      end
    end

    context "when trying to move not according to knight rules" do
      it "returns false" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([2, 2]).and_return(nil)
        res = test_knight.valid_move?(from: [0, 0], to: [2, 2], board: test_board)
        expect(res).to be false
      end
    end
  end

  describe "#valid_moves" do
    context "when knight is landing on empty squares" do
      it "returns all available squares" do
        test_board = double
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_knight.valid_moves(from: [4, 4], board: test_board)
        expect(res.length).to eq(8)
      end
    end

    context "when at the edge of the board" do
      it "returns only squares on the board" do
        test_board = double
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true, false)
        res = test_knight.valid_moves(from: [4, 4], board: test_board)
        expect(res.length).to eq(1)
      end
    end

    context "when blocked by teammate" do
      it "returns only squares not blocked by teammate" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_teammate)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_knight.valid_moves(from: [4, 4], board: test_board)
        expect(res.length).to eq(0)
      end
    end

    context "when landing on opponent" do
      it "returns only squares with opponents" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_opponent)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_knight.valid_moves(from: [4, 4], board: test_board)
        expect(res.length).to eq(8)
      end
    end
  end
end
