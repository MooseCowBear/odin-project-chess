require_relative "../lib/players/human_player"

describe HumanPlayer do
  subject(:test_player) { described_class.new(name: "bob") }

  describe "#move" do
    it "receives input and calls move converter convert method" do
      allow($stdin).to receive(:gets).and_return(double())
      move_double = double()
      allow_any_instance_of(MoveConverter).to receive(:convert).and_return(move_double)
      res = test_player.move([])
      expect(res).to be(move_double)
    end
  end
end