require_relative '../lib/path_checker.rb'

describe PathChecker do
  let(:dummy_class) { Class.new { extend PathChecker } }
  let(:elem) { double(color: "black") }
  let(:test_board) { 
    [
      [elem, nil, elem, nil],
      [nil, nil, nil, elem],
      [nil, nil, elem, nil],
      [nil, nil, nil, nil]
    ]
  }

  describe '#clear_non_vertical_path?' do
    context 'when there is a clear diagonal path' do
      it 'returns true' do
        path = dummy_class.clear_non_vertical_path?("white", test_board, [0, 0], [2, 2], 1)
        expect(path).to be true
      end
    end

    context 'when the diagonal path is not clear' do
      it 'returns false' do
        path = dummy_class.clear_non_vertical_path?("white", test_board, [0, 0], [3, 3], 1)
        expect(path).to be false
      end

      it 'returns false' do
        path = dummy_class.clear_non_vertical_path?("white", test_board, [3, 3], [0, 0], 1) 
        expect(path).to be false
      end
    end

    context 'when there is a clear horizontal path' do
      it 'returns true' do
        path = dummy_class.clear_non_vertical_path?("white", test_board, [0, 0], [0, 2], 0) 
        expect(path).to be true
      end
    end

    context 'when the horizontal path is not clear' do
      it 'returns false' do
        path = dummy_class.clear_non_vertical_path?("white", test_board, [0, 0], [0, 3], 0)
        expect(path).to be false
      end
    end

    context 'when slope is negative' do
      it 'returns false' do
        path = dummy_class.clear_non_vertical_path?("white", test_board, [1, 3], [3, 1], -1)
        expect(path).to be false
      end
    end
  end

  describe '#clear_vertical_path?' do
    context 'when there is a clear path' do
      it 'returns true' do
        path = dummy_class.clear_vertical_path?("white", test_board, [0, 2], [2, 2])
        expect(path).to be true
      end
    end

    context 'when the path is not clear' do
      it 'returns false' do
        path = dummy_class.clear_vertical_path?("white", test_board, [0, 2], [3, 2])
        expect(path).to be false
      end

      it 'returns false' do
        path = dummy_class.clear_vertical_path?("white", test_board, [3, 2], [0, 2]) 
        expect(path).to be false
      end
    end
  end
end