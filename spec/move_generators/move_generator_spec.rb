require_relative "../../lib/move_generators/move_generator.rb"
require_relative "../../lib/pin/pin_finder"
require_relative "../../lib/move_generators/castle_generator"
require_relative "../../lib/moves/enpassant"
require_relative "../../lib/moves/move"

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

      expect(test_generator.class.name).to eq("ChecklessMoveGenerator")
    end
  end

  describe "#moves" do
    it "raises exception" do
      test_generator = MoveGenerator.new(
        double(), 
        double(), 
        [], 
        double()
      )
      msg = "This method needs to be defined in the subclass"
      expect { test_generator.moves }.to raise_error(msg)
    end
  end
end