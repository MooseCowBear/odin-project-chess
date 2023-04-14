require_relative '../lib/king.rb'

describe King do
  subject(:test_king) { described_class.new }

  describe '#valid_move?' do 
    let(:board) { 
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    }

    context 'when king is trying to move left one space' do
      it 'returns true' do
        start_pt = [1, 1]
        end_pt = [1, 2]
        res = test_king.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when king is trying to move down one space' do
      it 'returns true' do
        start_pt = [1, 1]
        end_pt = [2, 1]
        res = test_king.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when king is trying to move diagonally one space' do
      it 'returns true' do
        start_pt = [1, 1]
        end_pt = [2, 2]
        res = test_king.valid_move?(board, start_pt, end_pt)
        expect(res).to be true
      end
    end

    context 'when king tries to move more than one space' do
      it 'returns false' do
        start_pt = [1, 1]
        end_pt = [3, 2]
        res = test_king.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end
  end

  describe '#get_adjacent_positions' do
    context 'when king is not touching a side of the board' do
      it 'returns less than 8 squares' do
        pos = [0, 0]
        adj = test_king.get_adjacent_positions(pos)
        expect(adj).to contain_exactly [1, 0], [0, 1], [1, 1]
      end
    end

    context 'when king is on a side of the board' do
      it 'returns 8 squares' do
        pos = [1, 1]
        adj = test_king.get_adjacent_positions(pos)
        expect(adj). to contain_exactly [0, 0], [0, 1], [0, 2], [1, 0], [1, 2], [2, 0], [2, 1], [2, 2]
      end
    end
  end
end
