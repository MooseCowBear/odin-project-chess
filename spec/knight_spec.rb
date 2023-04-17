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

    context 'when the slope is 1' do 
      it 'returns false' do
        start_pt = [2, 2]
        end_pt = [3, 3]
        res = test_knight.valid_move?(board, start_pt, end_pt)
        expect(res).to be false
      end
    end
  end

  describe '#moves' do
    subject(:test_knight) { described_class.new }
    let(:opponent) { double(color: "black") }
    let(:teammate) { double(color: "white") }

    context 'when knight is in the middle of the board' do
      let(:moves_board) { 
    
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, test_knight, nil, nil, nil, nil], # 3,3
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns the 8 expected moves' do
        res = test_knight.moves(moves_board, [3, 3])
        value_to_check = res[[3, 3]]

        expect(value_to_check).to match_array([[1, 4], [4, 1], [1, 2], [2, 1], [4, 5], [5, 4], [2, 5], [5, 2]])
      end
    end

    context 'when knight is at the edge of the board' do
      let(:moves_board) { 
    
        [
          [test_knight, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns only moves on the board' do
        res = test_knight.moves(moves_board, [0, 0])
        value_to_check = res[[0, 0]]

        expect(value_to_check).to match_array([[1, 2], [2, 1]])
      end
    end
  end
end
