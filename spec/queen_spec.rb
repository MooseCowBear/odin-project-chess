require_relative '../lib/queen.rb'

describe Queen do
  describe '#valid_move?' do
    subject(:test_queen) { described_class.new }
    let(:board) { 
      [
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        ["x", nil, "Q", "x", nil, nil],
        [nil, nil, "x", nil, nil, nil],
        [nil, nil, nil, nil, "x", nil],
        [nil, nil, nil, nil, nil, nil]
      ]
    }

    context 'when the move is horizontal and there is no other element in the way' do
      it 'returns true' do
        start_pt = [2, 2]
        end_pt = [2, 1]
        res = test_queen.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when the move is horizontal and there is an element in the way' do
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [2, 4]
        res = test_queen.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when the move is vertical and there is no other element in the way' do
      it 'returns true' do
        start_pt = [2, 2]
        end_pt = [0, 2]
        res = test_queen.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when the move is vertical and there is an element in the way' do
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [4, 2]
        res = test_queen.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when the move has a slope with absolute value of 1 and there is no other element in the way' do
      it 'returns true' do
        start_pt = [2, 2]
        end_pt = [4, 4]
        res = test_queen.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end

      it 'returns true' do
        start_pt = [2, 2]
        end_pt = [0, 0]
        res = test_queen.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when the move has a slope of 1 and there is an element in the way' do
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [5, 5]
        res = test_queen.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when the slope is not contained in the slopes set' do
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [1, 4]
        res = test_queen.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end
  end
end