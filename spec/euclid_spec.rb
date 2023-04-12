require_relative '../lib/euclid.rb'

describe Euclid do
  let(:dummy_class) { Class.new { extend Euclid } }

  describe '#slope' do
    context 'when slope is positive' do
      let(:x1) { 0 }
      let(:y1) { 0 }
      let(:x2) { 1 }
      let(:y2) { 1 }

      it 'returns the expected slope' do
        slope = dummy_class.slope(x1, y1, x2, y2)
        expect(slope).to eq(1)
      end
    end

    context 'when slope is negative' do
      let(:x1) { 1 }
      let(:y1) { 3 }
      let(:x2) { 3 }
      let(:y2) { 1 }

      it 'returns the expected slope' do
        slope = dummy_class.slope(x1, y1, x2, y2)
        expect(slope).to eq(-1)
      end
    end

    context 'when slope if undefined' do
      let(:x1) { 2 }
      let(:y1) { 0 }
      let(:x2) { 2 }
      let(:y2) { 2 }

      it 'returns the expected slope' do
        slope = dummy_class.slope(x1, y1, x2, y2)
        expect(slope).to be_nil
      end
    end
  end

  describe '#distance' do
    context 'when xs and ys are non-negative' do
      let(:x1) { 1 }
      let(:y1) { 1 }
      let(:x2) { 2 }
      let(:y2) { 2 }

      it 'returns the expected distance' do
        expected = Math.sqrt(2)
        dist = dummy_class.distance(x1, y1, x2, y2)
        expect(dist).to eq(expected)
      end
    end

    context 'when there are a mix of non-negative and negative input values' do
      let(:x1) { 1 }
      let(:y1) { 1 }
      let(:x2) { -2 }
      let(:y2) { 5 }

      it 'returns the expected distance' do
        expected = 5
        dist = dummy_class.distance(x1, y1, x2, y2)
        expect(dist).to eq(expected)
      end
    end

    context 'when xs and ys are negative' do
      let(:x1) { -1 }
      let(:y1) { -1 }
      let(:x2) { -3 }
      let(:y2) { -2 }

      it 'returns the expected distance' do
        expected = Math.sqrt(5)
        dist = dummy_class.distance(x1, y1, x2, y2)
        expect(dist).to eq(expected)
      end
    end
  end
end