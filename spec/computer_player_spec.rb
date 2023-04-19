require_relative '../lib/computer_player.rb'

describe ComputerPlayer do
  subject(:comp) { described_class.new }

  describe '#moves_to_arr' do
    let(:mock_castle) { double(king_start: [1, 1], king_end: [2, 2]) }
    let(:mock_enpassant) { double(from: [3, 3], to: [4, 4]) }
    let(:mock_moves) { { [0, 0] => [[1, 2], [1, 3]] } }

    context 'when in check' do 
      it 'returns arr of nonspecial moves and enpassant moves' do
        res = comp.moves_to_arr(true, mock_moves, [mock_castle], [mock_enpassant])
        expect(res).to match_array(
          [
            [[3, 3], [4, 4]],
            [[0, 0], [1, 2]],
            [[0, 0], [1, 3]]
          ]
        )
      end
    end

    context 'when not in check' do 
      it 'returns arr of all moves' do
        res = comp.moves_to_arr(false, mock_moves, [mock_castle], [mock_enpassant])
        expect(res).to match_array(
          [
            [[3, 3], [4, 4]],
            [[0, 0], [1, 2]],
            [[0, 0], [1, 3]],
            [[1, 1], [2, 2]]
          ]
        )
      end
    end
  end
end