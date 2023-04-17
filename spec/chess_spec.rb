require_relative '../lib/chess.rb'

describe Chess do
  subject(:test_chess) { described_class.new }

  describe '#move_on_board?' do
    context 'when given a correct 4 letter-number move' do
      it 'returns true' do
        res = test_chess.move_on_board?("a3g5")
        expect(res).to be true
      end
    end

    context 'when given move more than 4 letters/numbers long' do
      it 'returns false' do
        res = test_chess.move_on_board?("a3g5b")
        expect(res).to be false
      end
    end

    context 'when given letter outside of range' do
      it 'returns false' do
        res = test_chess.move_on_board?("z2b4")
        expect(res).to be false
      end
    end

    context 'when given number outside of range' do
      it 'returns false' do
        res = test_chess.move_on_board?("a3g9b")
        expect(res).to be false
      end
    end

    context 'when letters, numbers inverted' do
      it 'returns false' do
        res = test_chess.move_on_board?("3a5g")
        expect(res).to be false
      end
    end
  end

  describe 'convert_move' do
    it 'converts move as expected' do
      move = "a8h1"
      res = test_chess.convert_move(move)
      expect(res).to eq [[0, 0], [7, 7]]
    end

    context 'when letters are capitalized' do
      it 'converts as expected' do
        move = "D5F4"
        res = test_chess.convert_move(move)
        expect(res).to eq [[3, 3], [4, 5]]
      end
    end
  end

  describe '#get_checks_and_pins' do
    context 'when starting board position' do
      it 'finds no checks' do
        res = test_chess.get_checks_and_pins([3, 3], "white", "black")
        checks = res["checks_arr"]
        expect(checks).to match_array([])
      end

      it 'finds no pins' do
        res = test_chess.get_checks_and_pins([3, 3], "white", "black")
        checks = res["pins_arr"]
        expect(checks).to match_array([])
      end
    end

    context 'when there are multiple checks and pins' do
      it 'finds all checks and pins' do
        king = King.new("white")
        tm_rook = Rook.new(0, "white")
        tm_knight = Knight.new(0, "white")

        op_rook = Rook.new(0, "black")
        op_bishop = Bishop.new(0, "black")
        op_knight = Knight.new(0, "black")

        checks_board = [
          [nil, nil, nil, nil, nil, nil, nil, tm_rook], #tm rook at 0, 7
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [tm_knight, nil, nil, nil, nil, nil, nil, nil], #tm knight at 2, 0
          [nil, nil, nil, king, nil, nil, tm_rook, op_rook], #king at 3, 3, op rook at 3, 7, tm rook at 3, 6
          [nil, op_knight, nil, nil, nil, nil, nil, nil], #op knight at 4, 1
          [nil, nil, nil, nil, nil, op_bishop, nil, nil], #op bishop at 5, 5
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]

        test_chess.board = checks_board
        res = test_chess.get_checks_and_pins([3, 3], "white", "black")
        checks = res["checks_arr"]
        expect(checks.length).to eq(2) 
      end
    end

    context 'when called with want pins parameter as false' do
      it 'returns the attacking pieces to specified square' do
        king = King.new("white")
        tm_rook = Rook.new(0, "white")
        tm_knight = Knight.new(0, "white")

        op_rook = Rook.new(0, "black")
        op_bishop = Bishop.new(0, "black")
        op_knight = Knight.new(0, "black")

        checks_board = [
          [nil, nil, nil, nil, nil, nil, nil, tm_rook], #tm rook at 0, 7
          [nil, nil, nil, nil, nil, nil, nil, nil], 
          [tm_knight, nil, nil, nil, nil, nil, nil, nil], #tm knight at 2, 0
          [nil, nil, nil, king, nil, nil, tm_rook, op_rook], #king at 3, 3, op rook at 3, 7, tm rook at 3, 6
          [nil, op_knight, nil, nil, nil, nil, nil, nil], #op knight at 4, 1
          [nil, nil, nil, nil, nil, op_bishop, nil, nil], #op bishop at 5, 5
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        test_chess.board = checks_board
        res = test_chess.get_checks_and_pins([3, 3], "white", "black")
        checks = res["pins_arr"]
        expect(checks.length).to eq(1)
      end
    end
  end

  describe '#castle?' do
    context 'when the board is the starting board' do
      it 'returns false for queenside' do
        q = test_chess.queen_side
        res = test_chess.castle?(q)
        expect(res).to be false
      end

      it 'returns false for kingside' do
        k = test_chess.king_side
        res = test_chess.castle?(k)
        expect(res).to be false
      end
    end

    context 'when there is space between the king and rook and neither have moved and no squares are under attack' do
      it 'returns true if neither king, rook have moved' do
        test_chess.board[7][1] = nil
        test_chess.board[7][2] = nil
        test_chess.board[7][3] = nil
        q = test_chess.queen_side
        res = test_chess.castle?(q)
        expect(res).to be true
      end

      it 'returns false if one has moved' do
        test_chess.board[7][5] = nil
        test_chess.board[7][6] = nil
        test_chess.board[7][4].moved = true
        k = test_chess.king_side
        res = test_chess.castle?(k)
        expect(res).to be false
      end
    end
  end

  describe '#noncastling_king_moves' do
    let(:safe_board) {
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
      ]
    }
    context 'when no adjancent squares are in check' do
      it 'returns 8 possible moves' do
        test_chess.board = safe_board
        king = King.new
        test_chess.board[2][2] = king
        test_chess.white_king_position = [2, 2]
        res = test_chess.noncastling_king_moves
        to_check = res[[2, 2]]
        expect(to_check).to match_array([[1, 1], [1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2], [3, 3]])
      end
    end

    context 'when an adjacent squares are in check' do
      it 'excludes them from possible moves' do
        test_chess.board = safe_board
        king = King.new
        test_chess.board[2][2] = king
        test_chess.white_king_position = [2, 2]
        op_rook = Rook.new(0, "black")
        test_chess.board[2][0] = op_rook
        res = test_chess.noncastling_king_moves
        to_check = res[[2, 2]]
        expect(to_check).to match_array([[1, 1], [1, 2], [1, 3], [3, 1], [3, 2], [3, 3]])
      end
    end
  end

  describe '#squares_in_range' do
    context 'when the line is vertical' do
      it 'returns the expected squares' do
        pos1 = [3, 3]
        pos2 = [7, 3]
        res = test_chess.squares_in_range(pos1, pos2)
        expect(res).to match_array([[4, 3], [5, 3], [6, 3], [7, 3]])
      end
    end

    context 'when the line is horizontal' do
      it 'returns the expected squares' do
        pos1 = [3, 3]
        pos2 = [3, 7]
        res = test_chess.squares_in_range(pos1, pos2)
        expect(res).to match_array([[3, 4], [3, 5], [3, 6], [3, 7]])
      end
    end

    context 'when the line is diagonal' do
      it 'returns the expected squares' do
        pos1 = [3, 3]
        pos2 = [7, 7]
        res = test_chess.squares_in_range(pos1, pos2)
        expect(res).to match_array([[4, 4], [5, 5], [6, 6], [7, 7]])
      end
    end
  end

  describe '#defender_moves' do 
    king = King.new
    op_queen = Queen.new("black")
    rook = Rook.new
    knight = Knight.new

    let(:defender_board) { 
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, king, nil, nil, nil, nil],
        [rook, nil, nil, nil, nil, nil, nil, nil], 
        [nil, op_queen, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, knight, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
      ]
    }

    context 'when teammate piece can get king out of check' do
      it 'the move is included in defender moves' do
        test_chess.board = defender_board
        res = test_chess.defender_moves([3, 3], [5, 1])
        expect(res). to include(
          [4, 0] => [[4, 2]],
          [6, 3] => [[4, 2], [5, 1]]
        )
      end
    end
  end

  describe '#pin_moves' do
    king = King.new
    op_queen = Queen.new("black")
    rook = Rook.new
    let(:pin_board) { 
      [
        [king, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [rook, nil, nil, nil, nil, nil, nil, nil], 
        [queen, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
      ]
    }

    context 'when pin has moves it can make' do
      it 'returns pins moves' do
        pin = Pin.new(rook, [2, 0], [0, 0])
        pin.update_defense([3, 0])
        test_chess.pins << pin

        res = test_chess.pin_moves
        expect(res). to include(
          [2, 0] => [[1, 0], [3, 0]]
        )
      end
    end
  end

  describe '#update_en_passant' do
    context 'when the piece moved is not a pawn' do
      it 'does not update en_passant array' do
        piece = test_chess.board[7][1]
        test_chess.update_en_passant(piece, [7, 1], [6, 2])
        expect(test_chess.en_passant).to match_array([])
      end
    end

    context 'when the piece moved is a pawn, but it did not move 2 squares' do
      it 'does not update en_passant array' do
        piece = test_chess.board[6][1]
        test_chess.update_en_passant(piece, [6, 1], [5, 1])
        expect(test_chess.en_passant).to match_array([])
      end
    end

    context 'when a pawn has moved 2 spaces but has no neighbors' do
      it 'does not update en_passant array' do
        piece = test_chess.board[6][1]
        test_chess.update_en_passant(piece, [6, 1], [4, 1])
        expect(test_chess.en_passant).to match_array([])
      end
    end

    context 'when a pawn has moved 2 spaces and has 2 neighbors' do
      it 'adds both en passant moves' do
        test_chess.board[4][0], test_chess.board[1][0] = test_chess.board[1][0], nil

        test_chess.board[4][2], test_chess.board[1][2] = test_chess.board[1][2], nil

        piece = test_chess.board[6][1]
        test_chess.update_en_passant(piece, [6, 1], [4, 1])

        expect(test_chess.en_passant).to match_array([
          have_attributes(from: [4, 0], to: [5, 1], opponent_pawn_pos: [4, 1]),
          have_attributes(from: [4, 2], to: [5, 1], opponent_pawn_pos: [4, 1])
      ])
      end
    end
  end

  describe '#enpassant_rescues' do
    king = King.new("black")
    opawn = Pawn.new(0, "white")
    pawn = Pawn.new(0, "black")
    let(:ep_board) { 
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, king, nil, nil, nil, nil],
        [nil, pawn, opawn, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
      ]
    }
    context 'when an en passant rescue from check is available' do
      it 'updates the rescue property of the en passant object' do
        test_chess.board = ep_board
        test_chess.en_passant = [EnPassant.new([4, 1], [5, 2], [4, 2])]
        test_chess.checks = [[opawn, [4, 2], [3, 3]]]

        test_chess.enpassant_rescues

        expect(test_chess.en_passant[0].rescue).to be true
      end
    end
  end
end
