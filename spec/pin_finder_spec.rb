require_relative "../lib/pin/pin_finder.rb"

describe PinFinder do
  subject(:test_pin_finder) { described_class.new(double(), double(color: "white", position: [4, 4])) }

  describe "#walkout_direction" do
    context "when the pin lies on a diagonal from the king" do
      it "returns the correct offset when the slope between teammate and king is 1 and teammate has lower row, col" do
        test_teammate = double(color: "white", position: [1, 1])
        allow(test_pin_finder.board).to receive(:directions).and_return ([[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]])
        expect(test_pin_finder.walkout_direction(test_teammate)).to eq([-1, -1])
      end

      it "returns the correct offset when the slope between teammate and king is 1 and teammate has higher row, col" do
        test_teammate = double(color: "white", position: [5, 5])
        allow(test_pin_finder.board).to receive(:directions).and_return ([[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]])
        expect(test_pin_finder.walkout_direction(test_teammate)).to eq([1, 1])
      end

      it "returns the correct offset when the slope is -1 and teammate has higher row, lower col" do
        test_teammate = double(color: "white", position: [5, 3])
        allow(test_pin_finder.board).to receive(:directions).and_return ([[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]])
        expect(test_pin_finder.walkout_direction(test_teammate)).to eq([1, -1])
      end

      it "returns the correct offset when the slope is -1 and teammate has lower row, higher col" do
        test_teammate = double(color: "white", position: [3, 5])
        allow(test_pin_finder.board).to receive(:directions).and_return ([[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]])
        expect(test_pin_finder.walkout_direction(test_teammate)).to eq([-1, 1])
      end
    end

    context "when the pin lies on a lie vertical to the king" do
      it "returns correct offset when teammate has higher row than king" do
        test_teammate = double(color: "white", position: [6, 4])
        allow(test_pin_finder.board).to receive(:directions).and_return ([[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]])
        expect(test_pin_finder.walkout_direction(test_teammate)).to eq([1, 0])
      end

      it "returns correct offset when teammate has lower row than king" do
        test_teammate = double(color: "white", position: [2, 4])
        allow(test_pin_finder.board).to receive(:directions).and_return ([[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]])
        expect(test_pin_finder.walkout_direction(test_teammate)).to eq([-1, 0])
      end
    end

    context "when the pin lies on a line horizontal to the king" do
      it "returns correct offset when teammate has higher column than king" do
        test_teammate = double(color: "white", position: [4, 6])
        allow(test_pin_finder.board).to receive(:directions).and_return ([[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]])
        expect(test_pin_finder.walkout_direction(test_teammate)).to eq([0, 1])
      end

      it "returns correct offset when teammate has lower column than king" do
        test_teammate = double(color: "white", position: [4, 2])
        allow(test_pin_finder.board).to receive(:directions).and_return ([[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]])
        expect(test_pin_finder.walkout_direction(test_teammate)).to eq([0, -1])
      end
    end
  end

  describe "#get_pins" do
    
  end
end