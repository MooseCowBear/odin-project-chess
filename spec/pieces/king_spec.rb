require_relative '../../lib/pieces/king.rb'

describe King do
  subject(:test_king) { described_class.new(color: "white", position: [7, 4], promotable: false) } 

  describe "#valid_move?" do 
    context 'when king is trying to move left one space' do
      it "returns true when square is empty" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([1, 2]).and_return(nil)
        res = test_king.valid_move?(from: [1, 1], to: [1, 2], board: test_board)
        expect(res).to be true
      end

      it "returns true when square contains an opponent" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board). to receive(:get_piece).with([1, 2]).and_return(test_opponent)
        res = test_king.valid_move?(from: [1, 1], to: [1, 2], board: test_board)
        expect(res).to be true
      end

      it "returns false when square contains a teammate" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board). to receive(:get_piece).with([1, 2]).and_return(test_teammate)
        res = test_king.valid_move?(from: [1, 1], to: [1, 2], board: test_board)
        expect(res).to be false
      end
    end

    context "when king is trying to move down one space" do
      it "returns true when square is empty" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([2, 1]).and_return(nil)
        res = test_king.valid_move?(from: [1, 1], to: [2, 1], board: test_board)
        expect(res).to be true
      end

      it "returns true when square contains opponent" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board). to receive(:get_piece).with([2, 1]).and_return(test_opponent)
        res = test_king.valid_move?(from: [1, 1], to: [2, 1], board: test_board)
        expect(res).to be true
      end

      it "returns false when square contains teammate" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board). to receive(:get_piece).with([2, 1]).and_return(test_teammate)
        res = test_king.valid_move?(from: [1, 1], to: [2, 1], board: test_board)
        expect(res).to be false
      end
    end

    context "when king is trying to move diagonally one space" do
      it "returns true when square is empty" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([2, 2]).and_return(nil)
        res = test_king.valid_move?(from: [1, 1], to: [2, 2], board: test_board)
        expect(res).to be true
      end

      it "returns true when square contains opponent" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board). to receive(:get_piece).with([2, 2]).and_return(test_opponent)
        res = test_king.valid_move?(from: [1, 1], to: [2, 2], board: test_board)
        expect(res).to be true
      end

      it "returns false when square contains teammate" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board). to receive(:get_piece).with([2, 2]).and_return(test_teammate)
        res = test_king.valid_move?(from: [1, 1], to: [2, 2], board: test_board)
        expect(res).to be false
      end
    end

    context "when king tries to move more than one space" do
      it "returns false" do
        test_board = double
        allow(test_board).to receive(:get_piece).with([3, 2]).and_return(nil)
        res = test_king.valid_move?(from: [1, 1], to: [3, 2], board: test_board)
        expect(res).to be false
      end
    end
  end

  describe "#valid_moves" do
    context "when king is on the edge of the board" do
      it "returns only moves that are on the board" do
        test_board = double
        allow(test_board).to receive(:on_board?).with(anything).and_return(false, false, false, false, false, true)

        allow(test_board).to receive(:get_piece).with(anything).and_return(nil) 
        res = test_king.valid_moves(from: [0, 0], board: test_board) 
        expect(res.length).to eq(3)
      end
    end

    context "when king can freely move to any adjacent square" do
      it "returns 8 moves if surrounding squares are empty" do
        test_board = double
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil) 
        res = test_king.valid_moves(from: [0, 0], board: test_board) 
        expect(res.length).to eq(8)
      end

      it "returns 8 moves if surrounding squares contain opponents" do
        test_board = double
        test_opponent = double(color: "black")
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        allow(test_board).to receive(:get_piece).with(anything).and_return(test_opponent)
        res = test_king.valid_moves(from: [0, 0], board: test_board) 
        expect(res.length).to eq(8)
      end
    end

    context "when king's moves are limited by teammates" do
      it "returns only unblocked moves" do
        test_board = double
        test_teammate = double(color: "white")
        allow(test_board).to receive(:on_board?).with(anything).and_return(true)
        allow(test_board).to receive(:get_piece).with(anything).and_return(nil, test_teammate)
        res = test_king.valid_moves(from: [0, 0], board: test_board) 
        expect(res.length).to eq(1)
      end
    end
  end
end
