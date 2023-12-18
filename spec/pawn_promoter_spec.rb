require_relative "../lib/pawn_promoter"
require_relative "../lib/pieces/queen"
require_relative "../lib/pieces/bishop"
require_relative "../lib/pieces/rook"
require_relative "../lib/pieces/knight"

describe PawnPromoter do
  subject(:test_promoter) { described_class.new(double(), double(), double()) }

  describe "#promote" do
    it "updates the board if move was promotable" do
      allow(test_promoter).to receive(:promote?).and_return(true)
      allow(test_promoter.move).to receive(:to)
      expect(test_promoter).to receive(:get_promotion_choice)
      expect(test_promoter).to receive(:new_piece)
      expect(test_promoter.board).to receive(:update)
      test_promoter.promote
    end

    it "does nothing if move not promotable" do
      allow(test_promoter).to receive(:promote?).and_return(false)
      expect(test_promoter.board).not_to receive(:update)
      test_promoter.promote
    end
  end

  describe "#promote?" do
    it "returns true if move was promotable" do
      allow(test_promoter.move).to receive(:promote?).and_return(true)
      expect(test_promoter.promote?).to be(true)
    end

    it "returns false if move was not promotable" do
      allow(test_promoter.move).to receive(:promote?).and_return(false)
      expect(test_promoter.promote?).to be(false)
    end
  end

  describe "#get_promotion_choice" do
    it "asks for player's choice until provided a valid choice" do
      allow($stdin).to receive(:gets)
      allow(test_promoter.player).to receive(:promotion_choice)
      allow(test_promoter).to receive(:valid_promotion_choice?).and_return(false, false, true)
      expect(STDOUT).to receive(:puts).with("How would you like to promote your pawn?")
      expect(STDOUT).to receive(:puts).with("The options are: Queen, Bishop, Rook, Knight.").exactly(3).times
      test_promoter.get_promotion_choice
    end
  end

  describe "#valid_promotion_choice?" do
    context "when choice is among queen, bishop, knight, rook" do
      it "returns true" do
        choices = ["Queen", "Rook", "Bishop", "Knight"]
        choice = choices.sample
        expect(test_promoter.valid_promotion_choice?(choice)).to be(true)
      end
    end 
    
    context "when choice is not among queen, bishop, knight, rook" do
      it "returns false" do
        expect(test_promoter.valid_promotion_choice?("king")).to be(false)
      end
    end
  end

  describe "#new_piece" do
    it "creates new queen instance when choice is queens" do
      allow(test_promoter.player).to receive(:color)
      expect(Queen).to receive(:new)
      test_promoter.new_piece("queen", [0, 0])
    end

    it "creates new bishop instance when choice is bishop" do
      allow(test_promoter.player).to receive(:color)
      expect(Bishop).to receive(:new)
      test_promoter.new_piece("bishop", [0, 0])
    end

    it "creates new knight instance when choice is knight" do
      allow(test_promoter.player).to receive(:color)
      expect(Knight).to receive(:new)
      test_promoter.new_piece("knight", [0, 0])
    end

    it "creates new rook instance when choice is rook" do
      allow(test_promoter.player).to receive(:color)
      expect(Rook).to receive(:new)
      test_promoter.new_piece("rook", [0, 0])
    end
  end
end