require_relative '../lib/bishop.rb'

describe Bishop do
  describe '#valid_move?' do
    subject(:test_bishop) { described_class.new }
    let(:board) { 
      [
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        ["x", nil, "B", "x", nil, nil],
        [nil, nil, "x", nil, nil, nil],
        [nil, nil, nil, nil, "x", nil],
        [nil, nil, nil, nil, nil, nil]
      ]
    }

    context 'when trying to move on a diagonal with no obstacle' do
      it 'returns true' do
        start_pt = [2, 2]
        end_pt = [0, 0]
        res = test_bishop.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when trying to move on a diagonal with an obstacle' do
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [5, 5]
        res = test_bishop.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end

    context 'when trying to move not on a diagonal' do
      it 'returns false if there is no obstacle' do
        start_pt = [2, 2]
        end_pt = [3, 0]
        res = test_bishop.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end

      it 'returns false if there is an obstacle' do
        start_pt = [2, 2]
        end_pt = [0, 5]
        res = test_bishop.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end
  end
end