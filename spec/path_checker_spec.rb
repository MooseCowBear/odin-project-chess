require_relative '../lib/path_checker.rb'

describe PathChecker do
  let(:dummy_class) { Class.new { extend PathChecker } }
  let(:test_board) { 
    [
      ["x", nil, "x", nil],
      [nil, nil, nil, nil],
      [nil, nil, "x", nil],
      [nil, nil, nil, nil]
    ]
  }

  describe '#clearNonVerticalPath?' do
    context 'when there is a clear diagonal path' do
      it 'returns true' do
        path = dummy_class.clearNonVerticalPath?(test_board, [0, 0], [2, 2], 1)
        expect(path).to be true
      end
    end

    context 'when the diagonal path is not clear' do
      it 'returns false' do
        path = dummy_class.clearNonVerticalPath?(test_board, [0, 0], [3, 3], 1)
        expect(path).to be false
      end
    end

    context 'when there is a clear horizontal path' do
      it 'returns true' do
        path = dummy_class.clearNonVerticalPath?(test_board, [0, 0], [0, 2], 0) 
        expect(path).to be true
      end
    end

    context 'when the horizontal path is not clear' do
      it 'returns false' do
        path = dummy_class.clearNonVerticalPath?(test_board, [0, 0], [0, 3], 0)
        expect(path).to be false
      end
    end
  end

  describe '#clearVerticalPath?' do
    context 'when there is a clear path' do
      it 'returns true' do
        path = dummy_class.clearVerticalPath?(test_board, [0, 2], [2, 2])
        expect(path).to be true
      end
    end

    context 'when the path is not clear' do
      it 'returns false' do
        path = dummy_class.clearVerticalPath?(test_board, [0, 2], [3, 2])
        expect(path).to be false
      end
    end
  end
end