require_relative "../lib/pawn_promoter"

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
    it "returns new queen instance when choice is queens" do
    end

    it "returns new bishop instance when choice is bishop" do
    end

    it "returns new knight instance when choice is knight" do
    end

    it "returns new rook instance when choice is rook" do
    end
  end
end