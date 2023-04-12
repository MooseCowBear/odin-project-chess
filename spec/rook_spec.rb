require_relative '../lib/rook.rb'

describe Rook do
  describe '#valid_move?' do
    subject(:test_rook) { described_class.new }
    let(:board) { 
      [
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        ["x", nil, "R", "x", nil, nil],
        [nil, nil, "x", nil, nil, nil],
        [nil, nil, nil, nil, "x", nil],
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
end