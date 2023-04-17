require_relative '../lib/rook.rb'

describe Rook do
  describe '#valid_move?' do
    subject(:test_rook) { described_class.new }
    let(:elem) { double(color: "black") }
    let(:board) { 
      [
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [elem, nil, "R", elem, nil, nil],
        [nil, nil, elem, nil, nil, nil],
        [nil, nil, nil, nil, elem, nil],
        [nil, nil, nil, nil, nil, nil]
      ]
    }
    context 'when trying to move horizontally' do
      it 'returns true if there is no obstacle' do
        start_pt = [2, 2]
        end_pt = [2, 0]
        res = test_rook.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end

      it 'returns false if there is an obstacle' do
        start_pt = [2, 2]
        end_pt = [2, 4]
        res = test_rook.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when trying to move vertically' do
      it 'returns true if there is no obstacle' do
        start_pt = [2, 2]
        end_pt = [0, 2]
        res = test_rook.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end

      it 'returns false if there is an obstacle' do
        start_pt = [2, 2]
        end_pt = [4, 2]
        res = test_rook.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when trying to move at an angle' do
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [5, 5]
        res = test_rook.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end
  end

  describe '#moves' do
    subject(:test_rook) { described_class.new }
    let(:opponent) { double(color: "black") }
    let(:teammate) { double(color: "white") }

    context "when bishop's moves are constrained" do
      let(:moves_board) { 
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, opponent, nil, nil, nil, nil, nil], #opponent at 2, 3
          [nil, nil, test_rook, nil, nil, nil, teammate, nil], #rook at 2, 2, teammate at 2, 6
          [nil, nil, teammate, nil, nil, nil, nil, nil], #teammate at 3, 2
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns expected moves up to and including opponent but excluding teammates' do
        res = test_rook.moves(moves_board, [2, 2])
        value_to_check = res[[2, 2]]

        expect(value_to_check).to match_array([[2, 1], [2, 0], [1, 2], [2, 3], [2, 4], [2, 5]])
      end
    end

    context "when bishop's move are unconstrained" do
      let(:moves_board) { 
    
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, test_rook, nil, nil, nil, nil, nil], #rook at 2, 2
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns every square on each diagonal' do
        res = test_rook.moves(moves_board, [2, 2])
        value_to_check = res[[2, 2]]

        expect(value_to_check).to match_array([[2, 1], [2, 0], [1, 2], [0, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2]])
      end
    end
  end
end