require_relative "../../lib/players/player"

describe Player do
  subject(:test_player) { described_class.new(name: "alice", color: "white") }

  describe "#name" do
    it "returns its name" do
      expect(test_player.name).to eq("alice")
    end
  end

  describe "#move" do
    it "raises exception" do
      msg = "This method needs to be defined in the subclass"
      expect { test_player.move([]) }.to raise_error(msg)
    end
  end 
end