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

  describe '#moves' do
    subject(:test_bishop) { described_class.new }
    let(:opponent) { double(color: "black") }
    let(:teammate) { double(color: "white") }

    context "when bishop's moves are constrained" do
      let(:moves_board) { 
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, opponent, nil, nil, nil, nil], #opponent at 1, 3
          [nil, nil, test_bishop, nil, nil, nil, nil, nil], #bishop at 2, 2
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [teammate, nil, nil, nil, teammate, nil, nil, nil], #teammates at 4, 0 and 4, 4
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns expected moves up to and including opponent but excluding teammates' do
        res = test_bishop.moves(moves_board, [2, 2])
        value_to_check = res[[2, 2]]

        expect(value_to_check).to match_array([[0, 0], [1, 1], [3, 3], [1, 3], [3, 1]])
      end
    end

    context "when bishop's move are unconstrained" do
      let(:moves_board) { 
    
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, test_bishop, nil, nil, nil, nil, nil], #bishop at 2, 2
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      }

      it 'returns every square on each diagonal' do
        res = test_bishop.moves(moves_board, [2, 2])
        value_to_check = res[[2, 2]]

        expect(value_to_check).to match_array([[0, 0], [1, 1], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [1, 3], [0, 4], [3, 1], [4, 0]])
      end
    end
  end
end