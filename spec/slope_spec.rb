require_relative '../lib/modules/slope.rb'

describe Slope do
  let(:dummy_class) { Class.new { extend Slope } }

  describe '#slope' do
    context 'when slope is positive' do
      it 'returns the expected slope' do
        slope = dummy_class.slope([0, 0], [1, 1])
        expect(slope).to eq(1)
      end
    end

    context 'when slope is negative' do
      it 'returns the expected slope' do
        slope = dummy_class.slope([1, 3], [3, 1])
        expect(slope).to eq(-1)
      end
    end

    context 'when slope if undefined' do
      it 'returns the expected slope' do
        slope = dummy_class.slope([0, 2], [2, 2])
        expect(slope).to be_nil
      end
    end
  end
end