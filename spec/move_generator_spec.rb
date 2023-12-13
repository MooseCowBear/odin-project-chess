require_relative "../lib/move_generators/move_generator.rb"
require_relative "../lib/pin/pin_finder"
require_relative "../lib/move_generators/castle_generator"
require_relative "../lib/moves/enpassant"
require_relative "../lib/moves/move"

describe MoveGenerator do
  describe ".for" do
    it "creates a MultiCheckMoveGenerator when number of checks > 1" do
      test_generator = 
        MoveGenerator.for(
          king: double(color: "white", position: [2, 2]), 
          board: double(), 
          checks: [double(color: "black", position: [1, 1]), double(color: "black", position: [4, 2])], 
          last_move: double()
        ) 
      expect(test_generator.class.name).to eq("MultiCheckMoveGenerator")
    end

    it "creates a SingleCheckMoveGenerator when number of checks = 1" do
      test_generator = 
        MoveGenerator.for(
          king: double(color: "white", position: [2, 2]), 
          board: double(), 
          checks: [double(color: "black", position: [4, 2])], 
          last_move: double()
        ) 

      expect(test_generator.class.name).to eq("SingleCheckMoveGenerator")
    end

    it "creates a MoveGenerator when number of checks = 0" do
      test_generator = 
        MoveGenerator.for(
          king: double(color: "white", position: [2, 2]), 
          board: double(), 
          checks: [], 
          last_move: double()
        ) 

      expect(test_generator.class.name).to eq("MoveGenerator")
    end
  end

  describe "#moves" do
    it "combines king moves, non king moves, en passants, and castles" do
      test_generator = described_class.new(
        double(color: "white", position: [2, 2]), 
        double(), 
        [], 
        double()
      )

      one = double("one")
      two = double("two")
      three = double("three")
      four = double("four")

      allow(test_generator).to receive(:get_enpassant).and_return([one])
      allow_any_instance_of(CastleGenerator).to receive(:castles).and_return([two])
      allow(test_generator).to receive(:king_moves).and_return([three])
      allow(test_generator).to receive(:non_king_moves).and_return([four])
      
      res = test_generator.moves
      expect(res.length).to eq(4)
      expect(res.include?(one)).to be(true)
      expect(res.include?(two)).to be(true)
      expect(res.include?(three)).to be(true)
      expect(res.include?(four)).to be(true)
    end
  end

  describe "#king_moves" do
    it "returns king moves that are to squares that are not in check" do
      test_generator = described_class.new(
        double(color: "white", position: [2, 2]), 
        double(), 
        [], 
        double()
      )

      move_one = double(to: [1, 1])
      move_two = double(to: [1, 2])
      test_king_moves = [move_one, move_two]
      allow(test_generator.king).to receive(:valid_moves).and_return(test_king_moves)
      allow(test_generator).to receive(:unchecked_square?).and_return(true, false)

      res = test_generator.king_moves
      expect(res.length).to eq(1)
      expect(res.first).to be(move_one)
    end
  end

  describe "#get_enpassant" do
    it "returns en passant moves if they are available" do
      test_last_move = double(to: [4, 2], from: [6, 2], piece: double(color: "white", position: [4, 2], promotable: true))
      test_generator = described_class.new(
        double(color: "white", position: [2, 2]), 
        double(), 
        [], 
        test_last_move
      )
      one = double("one", position: [1, 1])
      two = double("two", position: [2, 2])
      allow(test_last_move).to receive(:check_enpassant?).and_return(true)
      allow(test_generator.board).to receive_message_chain(:column_neighbors, :filter).and_return([one, two])
      allow(one).to receive(:direction).and_return(1)
      allow(two).to receive(:direction).and_return(1)
      allow(EnPassant).to receive(:new).and_return(double("ep"))

      res = test_generator.get_enpassant
      expect(res.length).to eq(2)
    end

    it "returns an empty array if last move returns false for check_enpassant?" do
      test_last_move = double(to: [4, 2], from: [6, 2], piece: double(color: "white", position: [4, 2], promotable: true))
      test_generator = described_class.new(
        double(color: "white", position: [2, 2]), 
        double(), 
        [], 
        test_last_move
      )
      allow(test_last_move).to receive(:check_enpassant?).and_return(false)

      res = test_generator.get_enpassant
      expect(res).to eq([])
    end

    it "returns an empty array if no column neighbors" do
      test_last_move = double(to: [4, 2], from: [6, 2], piece: double(color: "white", position: [4, 2], promotable: true))
      test_generator = described_class.new(
        double(color: "white", position: [2, 2]), 
        double(), 
        [], 
        test_last_move
      )
      allow(test_last_move).to receive(:check_enpassant?).and_return(true)
      allow(test_generator.board).to receive_message_chain(:column_neighbors, :filter).and_return([])

      res = test_generator.get_enpassant
      expect(res).to eq([])
    end
  end

  describe "#piece_moves" do
    context "when piece is not a pin" do
      it "calls piece moves" do
        test_generator = described_class.new(
          double(color: "white", position: [2, 2]), 
          double(), 
          [], 
          double()
        )
        test_pins = double()
        test_piece = double(position: [4, 4])
        allow(test_pins).to receive(:index).and_return(nil)

        expect(test_piece).to receive(:valid_moves)
        test_generator.piece_moves(test_piece, test_pins)
      end
    end

    context "when piece is a pin" do
      it "calls pin moves" do
        test_generator = described_class.new(
          double(color: "white", position: [2, 2]), 
          double(), 
          [], 
          double()
        )
        test_piece = double(position: [4, 4])
        test_pin = double(piece: test_piece)
        test_pins = [test_pin]
        
        expect(test_generator).to receive(:pin_moves)
        test_generator.piece_moves(test_piece, test_pins)
      end
    end

    context "when piece is king" do
      it "returns empty array" do
        test_king = double(color: "white", position: [2, 2])
        test_generator = described_class.new(
          test_king, 
          double(), 
          [], 
          double()
        )

        test_pins = double()
        allow(test_pins).to receive(:index).and_return(nil)

        expect(test_generator.piece_moves(test_king, test_pins))
      end
    end
  end

  describe "#pin_moves" do
    context "when there are no en passant pin moves" do
      it "returns moves equal to the number of squares the piece has a valid move to" do
        test_king = double(color: "white", position: [3, 3])
        test_generator = described_class.new(
          test_king, 
          double(), 
          [], 
          double()
        )

        test_pin = double(piece: double(position: [1, 1]))
        allow(test_pin).to receive(:attacker).and_return(double(position: [0, 0]))
        allow(test_pin).to receive(:position).and_return([1, 1])
        allow(test_generator).to receive(:squares_in_range).and_return([[0, 0], [1, 1], [2, 2]])
        allow(test_pin).to receive(:valid_move?).with(anything).and_return(true)
        allow(test_generator.board).to receive(:get_piece).and_return(nil)
        allow(Move).to receive(:new).and_return(double())
        allow(test_generator).to receive(:enpassant).and_return([])

        res = test_generator.pin_moves(test_pin)
        expect(res.length).to eq(2)
      end
    end

    context "when there is an en passant pin moves" do
      it "returns the en passant move in the array of pin moves" do
        test_king = double(color: "white", position: [3, 3])
        test_generator = described_class.new(
          test_king, 
          double(), 
          [], 
          double()
        )

        test_pin = double(piece: double(position: [1, 1]))
        allow(test_pin).to receive(:attacker).and_return(double(position: [0, 0]))
        allow(test_pin).to receive(:position).and_return([1, 1])
        allow(test_generator).to receive(:squares_in_range).and_return([[0, 0], [1, 1]])
        allow(test_pin).to receive(:valid_move?).with(anything).and_return(false)
        ep_double = double()
        allow(test_generator).to receive(:enpassant).and_return(ep_double)
        allow(ep_double).to receive(:any?).and_return(true)
        allow(ep_double).to receive(:select).and_return([double("ep move")])

        res = test_generator.pin_moves(test_pin)
        expect(res.length).to eq(1)
      end
    end

    context "when there are no en passant pin moves and no valid pin moves" do
      it "returns an empty array" do
        test_king = double(color: "white", position: [3, 3])
        test_generator = described_class.new(
          test_king, 
          double(), 
          [], 
          double()
        )

        test_pin = double(piece: double(position: [1, 1]))
        allow(test_pin).to receive(:attacker).and_return(double(position: [0, 0]))
        allow(test_pin).to receive(:position).and_return([1, 1])
        allow(test_generator).to receive(:squares_in_range).and_return([[0, 0], [1, 1], [2, 2]])
        allow(test_pin).to receive(:valid_move?).with(anything).and_return(false)
        allow(test_generator).to receive(:enpassant).and_return([])

        res = test_generator.pin_moves(test_pin)
        expect(res.length).to eq(0)
      end
    end
  end

  describe "#non_king_moves" do
    it "calls piece moves once for each square on the board" do
      test_generator = described_class.new(
        double(color: "white", position: [2, 2]), 
        double(), 
        [], 
        double()
      )
      allow_any_instance_of(PinFinder).to receive(:get_pins).and_return([])
      allow(test_generator.board).to receive(:get_piece).and_return(double())
      expect(test_generator).to receive(:piece_moves).exactly(64).times
      test_generator.non_king_moves
    end
  end

  describe "#squares_in_range" do
    context "for a horizontal line between the king and opponent" do
      it "returns squares that include opponent square and exclude king when king column lower" do
        test_generator = described_class.new(
          double(color: "white", position: [1, 2]), 
          double(), 
          [], 
          double
        )
        test_opponent = double(position: [1, 6])
        allow(test_generator).to receive(:slope).and_return(0)

        res = test_generator.squares_in_range(test_opponent)
        expected = [[1, 3], [1, 4], [1, 5], [1, 6]]
        expected.each do |sq|
          expect(res.include?(sq)).to be(true)
        end
      end

      it "returns squares that include opponent square and exclude king when king column higher" do
        test_generator = described_class.new(
          double(color: "white", position: [1, 6]), 
          double(), 
          [], 
          double
        )
        test_opponent = double(position: [1, 2])
        allow(test_generator).to receive(:slope).and_return(0)

        res = test_generator.squares_in_range(test_opponent)
        expected = [[1, 3], [1, 4], [1, 5], [1, 2]]
        expected.each do |sq|
          expect(res.include?(sq)).to be(true)
        end
      end
    end

    context "for a diagonal line between king and opponent" do
      it "returns squares that include opponent square and exclude king when slope is negative" do
        test_generator = described_class.new(
          double(color: "white", position: [3, 3]), 
          double(), 
          [], 
          double
        )
        test_opponent = double(position: [1, 5])
        allow(test_generator).to receive(:slope).and_return(-1)

        res = test_generator.squares_in_range(test_opponent)
        expected = [[2, 4], [1, 5]]
        expected.each do |sq|
          expect(res.include?(sq)).to be(true)
        end
      end

      it "returns squares that include opponent square and exclude king when slope is positive" do
        test_generator = described_class.new(
          double(color: "white", position: [3, 3]), 
          double(), 
          [], 
          double
        )
        test_opponent = double(position: [4, 4])
        allow(test_generator).to receive(:slope).and_return(1)

        res = test_generator.squares_in_range(test_opponent)
        expected = [[4,4]]
        expected.each do |sq|
          expect(res.include?(sq)).to be(true)
        end
      end
    end

    context "for a vertical line between king and opponent" do
      it "returns squares that include opponent square and exclude king when king is lower row" do
        test_generator = described_class.new(
          double(color: "white", position: [3, 3]), 
          double(), 
          [], 
          double
        )
        test_opponent = double(position: [0, 3])
        allow(test_generator).to receive(:slope).and_return(nil)

        res = test_generator.squares_in_range(test_opponent)
        expected = [[2, 3], [1, 3], [0, 3]]
        expected.each do |sq|
          expect(res.include?(sq)).to be(true)
        end
      end

      it "returns squares that include opponent square and exclude king when king is higher row" do
        test_generator = described_class.new(
          double(color: "white", position: [0, 3]), 
          double(), 
          [], 
          double
        )
        test_opponent = double(position: [3, 3])
        allow(test_generator).to receive(:slope).and_return(nil)

        res = test_generator.squares_in_range(test_opponent)
        expected = [[2, 3], [1, 3], [3, 3]]
        expected.each do |sq|
          expect(res.include?(sq)).to be(true)
        end
      end
    end
  end
end