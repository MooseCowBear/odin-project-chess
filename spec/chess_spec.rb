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
end
