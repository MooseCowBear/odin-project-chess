require_relative '../lib/pieces/queen.rb'

describe Queen do
  describe '#valid_move?' do
    subject(:test_queen) { described_class.new }
    let(:elem) { double(color: "black") }
    let(:board) { 
      [
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [elem, nil, "Q", elem, nil, nil],
        [nil, nil, elem, nil, nil, nil],
        [nil, nil, nil, nil, elem, nil],
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

  describe '#moves' do
    subject(:test_queen) { described_class.new }
    let(:opponent) { double(color: "black") }
    let(:teammate) { double(color: "white") }

    context "when bishop's moves are constrained" do
      let(:moves_board) { 
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, opponent, opponent, opponent, nil, nil, nil, nil], 
          [nil, opponent, test_queen, opponent, nil, nil, nil, nil], #q at 2, 2
          [nil, teammate, teammate, teammate, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns expected moves up to and including opponent but excluding teammates' do
        res = test_queen.moves(moves_board, [2, 2])
        value_to_check = res[[2, 2]]

        expect(value_to_check).to match_array([[1, 1], [1, 2], [1, 3], [2, 1], [2, 3]])
      end
    end

    context "when bishop's move are unconstrained" do
      let(:moves_board) { 
    
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, test_queen, nil, nil, nil, nil, nil], # at 2, 2
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns every square on each diagonal' do
        res = test_queen.moves(moves_board, [2, 2])
        value_to_check = res[[2, 2]]
        moves = [
          [0, 0], [1, 1], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [1, 3], [0, 4], [3, 1], [4, 0],
          [2, 1], [2, 0], [1, 2], [0, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2]
        ]
        expect(value_to_check).to match_array(moves)
      end
    end
  end
end