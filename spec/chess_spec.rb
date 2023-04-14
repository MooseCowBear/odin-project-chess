require_relative '../lib/chess.rb'

describe Chess do
  subject(:test_chess) { described_class.new }

  describe '#on_board?' do
    context 'when given a correct 4 letter-number move' do
      it 'returns true' do
        res = test_chess.on_board?("a3g5")
        expect(res).to be true
      end
    end

    context 'when given move more than 4 letters/numbers long' do
      it 'returns false' do
        res = test_chess.on_board?("a3g5b")
        expect(res).to be false
      end
    end

    context 'when given letter outside of range' do
      it 'returns false' do
        res = test_chess.on_board?("z2b4")
        expect(res).to be false
      end
    end

    context 'when given number outside of range' do
      it 'returns false' do
        res = test_chess.on_board?("a3g9b")
        expect(res).to be false
      end
    end

    context 'when letters, numbers inverted' do
      it 'returns false' do
        res = test_chess.on_board?("3a5g")
        expect(res).to be false
      end
    end
  end

  describe 'convert_move' do
    it 'converts move as expected' do
      move = "a8h1"
      res = test_chess.convert_move(move)
      expect(res).to eq [[0, 0], [7, 7]]
    end

    context 'when letters are capitalized' do
      it 'converts as expected' do
        move = "D5F4"
        res = res = test_chess.convert_move(move)
        expect(res).to eq [[3, 3], [4, 5]]
      end
    end
  end

  #needed checked_by before castling, bc castling depends on it!!
  define '#checked_by' do
    let(:teammate) { double(color:"black") }
    let(:opponent1) { double(color:"white")}
    let(:opponent2) { double(color:"white") }
    let(:board) { 
      [
        [nil, nil, nil, opponent1, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "k", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, opponent2, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, teammate, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    }

    context 'when opponent pieces that have valid moves to the king' do
      let(:team_pos) { [6, 6] }
      let(:opp1_pos) { [0, 3] }
      let(:opp2_pos) { [5, 4] }
      let(:king_pos) { [3, 3] }

      before do
        allow(:opponent1).to receive(:valid_move?).with(board, opp1_pos, king_pos).and_return(true)
        allow(:opponent2).to receive(:valid_move?).with(board, opp2_pos, king_pos).and_return(true)
        allow(:teammate).to receive(:valid_move?).with(board, team_pos, king_pos).and_return(true)
      end 

      it 'returns positions of checking opponents' do 
        res = test_chess.checked_by("black", king_pos)
        expect(res).to contain_exactly [0, 3], [5, 4]
      end
    end

    context 'when there are no opponent pieces that have valid moves to the king' do
      let(:team_pos) { [6, 6] }
      let(:opp1_pos) { [0, 3] }
      let(:opp2_pos) { [5, 4] }
      let(:king_pos) { [3, 3] }

      before do
        allow(:opponent1).to receive(:valid_move?).with(board, opp1_pos, king_pos).and_return(false)
        allow(:opponent2).to receive(:valid_move?).with(board, opp2_pos, king_pos).and_return(false)
        allow(:teammate).to receive(:valid_move?).with(board, team_pos, king_pos).and_return(true)
      end

      it 'returns an empty list' do
        res = test_chess.checked_by("black", king_pos)
        expect(res).to eq([])
      end
    end
  end
end
