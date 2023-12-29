require_relative "../../lib/move_generators/castle_generator"

describe CastleGenerator do
  describe "#safe_passage?" do
    it "returns true if no square between min and max (inclusive) is in check" do
      test_king = double(color: "white", position: [7, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:unchecked_square?).with(anything).and_return(true)

      res = test_generator.safe_passage?(7, 4, 2)
      expect(res).to be(true)
    end

    it "returns false if any square between min and max (inclusive) is in check" do
      test_king = double(color: "white", position: [7, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:unchecked_square?).with(anything).and_return(false, true)

      res = test_generator.safe_passage?(7, 4, 2)
      expect(res).to be(false)
    end
  end

  describe "#clear_passage?" do
    it "returns true if no square between min and max (exclusive) is occupied" do
      test_king = double(color: "white", position: [7, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_board).to receive(:get_piece).with(anything).and_return(nil)

      res = test_generator.clear_passage?(7, 4, 2)
      expect(res).to be(true)
    end

    it "returns false if any square between min and max (exclusive) is occupied" do
      test_king = double(color: "white", position: [7, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_board).to receive(:get_piece).with(anything).and_return(double(), nil)

      res = test_generator.clear_passage?(7, 4, 2)
      expect(res).to be(false)
    end
  end

  describe "#clear_and_safe_passage?" do
    it "returns true if passage is both safe and clear" do
      test_king = double(color: "white", position: [7, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:safe_passage?).and_return(true)
      allow(test_generator).to receive(:clear_passage?).and_return(true)

      res = test_generator.clear_and_safe_passage?(double(position: [7, 0]), 1)
      expect(res).to be(true)
    end

    it "returns false if passage is unsafe" do
      test_king = double(color: "white", position: [7, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:safe_passage?).and_return(false)
      allow(test_generator).to receive(:clear_passage?).and_return(true)

      res = test_generator.clear_and_safe_passage?(double(position: [7, 0]), 1)
      expect(res).to be(false)
    end

    it "returns false if passage is not clear" do
      test_king = double(color: "white", position: [7, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:safe_passage?).and_return(true)
      allow(test_generator).to receive(:clear_passage?).and_return(false)

      res = test_generator.clear_and_safe_passage?(double(position: [7, 0]), 1)
      expect(res).to be(false)
    end
  end

  describe "#kingside_rook" do
    it "asks board for piece at black king_side rook position if king is black" do
      test_king = double(position: [0, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_king).to receive(:white?).and_return(false)

      expect(test_board).to receive(:get_piece).with([0, 7])
      test_generator.kingside_rook
    end

    it "asks board for piece at white king_side rook position if king is white" do
      test_king = double(position: [7, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_king).to receive(:white?).and_return(true)
      
      expect(test_board).to receive(:get_piece).with([7, 7])
      test_generator.kingside_rook
    end
  end

  describe "#queenside_rook" do
    it "asks board for piece at black queen_side rook position if king is black" do
      test_king = double(position: [0, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_king).to receive(:white?).and_return(false)
      
      expect(test_board).to receive(:get_piece).with([0, 0])
      test_generator.queenside_rook
    end

    it "asks board for piece at white queen_side rook position if king is white" do
      test_king = double(position: [7, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_king).to receive(:white?).and_return(true)
      
      expect(test_board).to receive(:get_piece).with([7, 0])
      test_generator.queenside_rook
    end
  end

  describe "#castleable?" do
    it "returns false if no piece at rook position" do
      test_king = double()
      test_board = double()
      test_generator = described_class.new(test_king, test_board)

      expect(test_generator.castleable?(nil, 2)).to be(false)
    end

    it "returns false if piece at rook position has been moved" do
      test_king = double()
      test_board = double()
      test_rook = double(moved: true)
      test_generator = described_class.new(test_king, test_board)

      expect(test_generator.castleable?(test_rook, 2)).to be(false)
    end

    it "returns false if passage is not clear and safe" do
      test_king = double()
      test_board = double()
      test_rook = double(moved: false)
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:clear_and_safe_passage?).and_return(false)

      expect(test_generator.castleable?(test_rook, 2)).to be(false)
    end

    it "returns true if unmoved piece at rook position and passage is safe and clear" do
      test_king = double()
      test_board = double()
      test_rook = double(moved: false)
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:clear_and_safe_passage?).and_return(true)

      expect(test_generator.castleable?(test_rook, 2)).to be(true)
    end
  end

  describe "#kingside" do
    it "creates a new castle move if castleable" do
      test_king = double(position: [0, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:kingside_rook).and_return(double(position: [0, 7]))
      allow(test_generator).to receive(:castleable?).and_return(true)

      res = test_generator.kingside
      expect(res.from).to eq([0, 4])
      expect(res.to).to eq([0, 6])
      expect(res.additional_from).to eq([0, 7])
      expect(res.additional_to).to eq([0, 5])
    end

    it "does not create a new castle move if not castleable" do
      test_king = double(position: [0, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:kingside_rook).and_return(double(position: [0, 7]))
      allow(test_generator).to receive(:castleable?).and_return(false)

      res = test_generator.kingside
      expect(res).to eq(nil)
    end
  end

  describe "#queenside" do
    it "creates a new castle move if castleable" do
      test_king = double(position: [0, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:queenside_rook).and_return(double(position: [0, 0]))
      allow(test_generator).to receive(:castleable?).and_return(true)

      res = test_generator.queenside
      expect(res.from).to eq([0, 4])
      expect(res.to).to eq([0, 2])
      expect(res.additional_from).to eq([0, 0])
      expect(res.additional_to).to eq([0, 3])
    end

    it "does not create a new castle move if not castleable" do
      test_king = double(position: [0, 4])
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:queenside_rook).and_return(double(position: [0, 0]))
      allow(test_generator).to receive(:castleable?).and_return(false)

      res = test_generator.queenside
      expect(res).to eq(nil)
    end
  end

  describe "#castles" do
    it "returns an empty array if king has been moved" do
      test_king = double(position: [0, 4], moved: true)
      test_board = double()
      test_generator = described_class.new(test_king, test_board)

      expect(test_generator.castles).to eq([])
    end

    it "returns an array of whose length is equal to the number of available castle moves" do
      test_king = double(position: [0, 4], moved: false)
      test_board = double()
      test_generator = described_class.new(test_king, test_board)
      allow(test_generator).to receive(:queenside).and_return("something")
      allow(test_generator).to receive(:kingside).and_return(nil)

      expect(test_generator.castles.length).to eq(1)
    end
  end
end