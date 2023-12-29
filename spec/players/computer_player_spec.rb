require_relative '../../lib/players/computer_player.rb'

describe ComputerPlayer do
  subject(:test_player) { described_class.new }

  describe "#move" do 
    it "returns a random move from moves" do
      test_moves = [double("one"), double("two"), double("three")]
      res = test_player.move(test_moves)
      expect(test_moves.include?(res))
    end
  end
end