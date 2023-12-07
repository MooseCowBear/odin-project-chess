require_relative '../lib/pieces/pawn.rb'

describe Pawn do
  subject(:test_pawn) { described_class.new(color: "white", position: [6, 2]) }

  describe '#valid_move?' do
    context "moving one space forward" do
      it "returns true if moving to a free board space" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([5, 2]).and_return(nil)
        res = test_pawn.valid_move?(from: [6, 2], to: [5, 2], board: test_board)
        expect(res).to be true
      end

      it "returns false if moving to a space occupied by opponent" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:get_piece).with([5, 2]).and_return(test_opponent)
        res = test_pawn.valid_move?(from: [6, 2], to: [5, 2], board: test_board)
        expect(res).to be false
      end

      it "returns false if moving to a space occupied by teammate" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with([5, 2]).and_return(test_teammate)
        res = test_pawn.valid_move?(from: [6, 2], to: [5, 2], board: test_board)
        expect(res).to be false
      end
    end

    context "move two spaces forward" do
      it "returns true if not moved and free board space" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([4, 2]).and_return(nil)
        res = test_pawn.valid_move?(from: [6, 2], to: [4, 2], board: test_board)
        expect(res).to be true
      end

      it "returns false if moved" do
        test_pawn.moved = true
        test_board = double
        allow(test_board).to receive(:get_piece).with([4, 2]).and_return(nil)
        res = test_pawn.valid_move?(from: [6, 2], to: [4, 2], board: test_board)
        expect(res).to be false
      end

      it "returns false if board space occupied by opponent" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:get_piece).with([4, 2]).and_return(test_opponent)
        res = test_pawn.valid_move?(from: [6, 2], to: [4, 2], board: test_board)
        expect(res).to be false
      end

      it "returns false if board space occupied by teammate" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with([4, 2]).and_return(test_teammate)
        res = test_pawn.valid_move?(from: [6, 2], to: [4, 2], board: test_board)
        expect(res).to be false
      end
    end

    context "moving more than 2 spaces forward" do
      it "returns false" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([3, 2]).and_return(nil)
        res = test_pawn.valid_move?(from: [6, 2], to: [3, 2], board: test_board)
        expect(res).to be false
      end
    end

    context "moving diagonally" do
      it "returns false when square empty" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([5, 3]).and_return(nil)
        res = test_pawn.valid_move?(from: [6, 2], to: [5, 3], board: test_board)
        expect(res).to be false
      end

      it "returns false when square occupied by teammate" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with([5, 3]).and_return(test_teammate)
        res = test_pawn.valid_move?(from: [6, 2], to: [5, 3], board: test_board)
        expect(res).to be false
      end

      it "returns true if square is occupied by opponent" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:get_piece).with([5, 3]).and_return(test_opponent)
        res = test_pawn.valid_move?(from: [6, 2], to: [5, 3], board: test_board)
        expect(res).to be true
      end
    end

    context "moving horizontally" do
      it "returns false" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([6, 3]).and_return(nil)
        res = test_pawn.valid_move?(from: [6, 2], to: [6, 3], board: test_board)
        expect(res).to be false
      end
    end

    context "moving at angle not diagonal" do
      it "returns false" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([5, 0]).and_return(nil)
        res = test_pawn.valid_move?(from: [6, 2], to: [5, 0], board: test_board)
        expect(res).to be false
      end
    end
  end

  describe "#valid_moves" do
    context "when pawn is unobstructed and no attacks" do
      it "returns 1 non attack move if moved and move is on board" do
        test_pawn.moved = true
        test_board = double
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_pawn.valid_moves(from: [6, 3], board: test_board)
        expect(res.length).to eq(1)
      end

      it "returns 2 non attack moves if not moved and moves are on board" do
        test_board = double
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_pawn.valid_moves(from: [6, 2], board: test_board)
        expect(res.length).to eq(2)
      end

      it "returns 0 moves if moved and move is off board" do
        test_pawn.moved = true
        test_board = double
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil)
        allow(test_board).to receive(:on_board?).with(anything).and_return(false)
        res = test_pawn.valid_moves(from: [0, 3], board: test_board)
        expect(res.length).to eq(0)
      end
    end

    context "when pawn is obstructed and no attacks" do
      it "returns 0 moves if piece in front of pawn" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_teammate)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_pawn.valid_moves(from: [6, 2], board: test_board)
        expect(res.length).to eq(0)
      end
    end

    context "when there are available attacks" do
      it "returns correct number of attacking moves" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_opponent)
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        res = test_pawn.valid_moves(from: [6, 2], board: test_board)
        expect(res.length).to eq(2)
      end
    end
  end
end