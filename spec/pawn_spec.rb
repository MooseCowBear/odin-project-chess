require_relative '../lib/pieces/pawn.rb'

describe Pawn do
  describe '#valid_move?' do
    subject(:test_pawn) { described_class.new(1, "black") }
    let(:teammate) { double(color:"black") }
    let(:opponent_pawn) { double(color:"white")}

    let(:board) { 
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "p", nil, nil, nil, nil],
        [nil, nil, nil, nil, opponent_pawn, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    }

    context 'when move is one space forward and there is a clear path' do
      it 'returns true' do
        start_pt = [1, 3]
        end_pt = [2, 3]
        res = test_pawn.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when move is two spaces, pawn has not moved yet, and there is a clear path' do
      it 'returns true' do
        start_pt = [1, 3]
        end_pt = [3, 3]
        res = test_pawn.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when trying to capture on the diagonal and there is an opponent piece to take' do
      it 'returns true' do
        start_pt = [1, 3]
        end_pt = [2, 4]
        res = test_pawn.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when trying to capture on the diagonal and there is no opponent piece to take' do
      it 'returns false' do
        start_pt = [1, 3]
        end_pt = [2, 2]
        res = test_pawn.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    #everything below requires alteration to orig set up
    context 'when move is one space but path is not clear' do
      it 'returns false' do
        board[2][3] = teammate
        start_pt = [1, 3]
        end_pt = [2, 3]
        res = test_pawn.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when tries to move two spaces, but pawn has already moved' do
      it 'returns false' do
        test_pawn.moved = true
        start_pt = [1, 3]
        end_pt = [3, 3]
        res = test_pawn.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when tries to capture on the diagonal but the piece is on same team' do
      it 'returns false' do
        board[2][2] = teammate
        start_pt = [1, 3]
        end_pt = [2, 2]
        res = test_pawn.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end
  end

  describe '#moves' do
    subject(:test_pawn) { described_class.new(1, "black") }
    let(:opponent) { double(color: "white") }
    let(:teammate) { double(color: "black") }

    context 'when the pawn has opponents to capture' do 
      let(:moves_board) { 
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, test_pawn, nil, nil, nil, nil, nil, nil], #1, 1
          [opponent, nil, opponent, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns moves that include captures' do
        res = test_pawn.moves(moves_board, [1, 1])
        value_to_check = res[[1, 1]]

        expect(value_to_check).to match_array([[2, 0], [2, 2], [2, 1], [3, 1]])
      end
    end

    context 'when the pawn has no captures, has not moved, has two free spaces before it' do
      let(:moves_board) { 
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, test_pawn, nil, nil, nil, nil, nil, nil], #1, 1
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns two possible moves' do
        res = test_pawn.moves(moves_board, [1, 1])
        value_to_check = res[[1, 1]]

        expect(value_to_check).to match_array([[2, 1], [3, 1]])
      end
    end
    context 'when the path is blocked and no captures available' do
      let(:moves_board) { 
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, test_pawn, nil, nil, nil, nil, nil, nil], #1, 1
          [nil, opponent, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns an empty hash' do
        res = test_pawn.moves(moves_board, [1, 1])
        value_to_check = res[[1, 1]]

        expect(value_to_check).to match_array([])
      end
    end
  end
end