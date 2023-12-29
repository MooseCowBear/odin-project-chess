require_relative "../../lib/pin/pin_finder.rb"

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
    it "creates a pin for each teammate that is blocking an opponent from attacking king" do
      test_opponent = double(color: "black", position: [3, 4])
      test_teammate_one = double(color: "white", position: [1, 4])
      test_teammate_two = double(color: "white", position: [3, 2])

      allow(test_pin_finder.board).to receive(:closest_neighbors).with(anything).and_return([[], [test_teammate_one, test_teammate_two]])
      allow(test_pin_finder.board).to receive(:directions).and_return ([[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]])
      allow(test_pin_finder.board).to receive(:closest_neighbor_in_direction).with(anything).and_return(test_opponent)
      allow(test_pin_finder.board).to receive(:get_piece).with(anything).and_return(test_opponent)
      allow(test_pin_finder.board).to receive(:under_attack?).with(anything).and_return(true, false)

      res = test_pin_finder.get_pins
      expect(res.length).to eq(1)
      expect(res.first.piece).to be(test_teammate_one)
      expect(res.first.attacker).to be(test_opponent)
    end
  end
end