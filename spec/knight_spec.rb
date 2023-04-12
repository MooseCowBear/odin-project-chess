require_relative '../lib/knight.rb'

describe Knight do
  describe '#valid_move?' do
    subject(:test_knight) { described_class.new }
    let(:board) { 
      [
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        ["x", nil, "K", "x", nil, nil, nil],
        [nil, nil, "x", nil, nil, nil, nil],
        [nil, nil, nil, nil, "x", nil, nil],
        [nil, nil, nil, nil, nil, nil, nil]
      ]
    }

    context 'when the slope is 2 and distance is correct' do
      it 'returns true' do
        start_pt = [2, 2]
        end_pt = [4, 3]
        res = test_knight.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when the slope is -0.5 and distance is correct' do
      it 'returns true' do
        start_pt = [2, 2]
        end_pt = [1, 4]
        res = test_knight.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when slope is correct but distance is not' do
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [4, 6]
        res = test_knight.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when the slope is nil' do
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [0, 2]
        res = test_knight.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when the slop is 1' do 
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [3, 3]
        res = test_knight.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end
  end
end
