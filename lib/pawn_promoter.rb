class PawnPromoter 
  attr_reader :move, :board, :player
  
  def initialize(move, board, player)
    @move = move
    @board = board
    @player = player
  end

  def promote
    if move.promote?
      board.update(position: move.to, value: new_piece(get_promotion_choice, move.to))
    end
  end

  def promote?
    move.promote?
  end

  def get_promotion_choice
    puts "How would you like to promote your pawn?"

    loop do 
      puts "The options are: Queen, Bishop, Rook, Knight."
      choice = player.promotion_choice
      return choice if valid_promotion_choice?(choice)
    end
  end

  def valid_promotion_choice?(input)
    ["queen", "bishop", "rook", "knight"].include?(input.downcase)
  end

  def new_piece(choice, position) 
    case choice
    when "queen"
      Queen.new(color: king.color, position: position)
    when "bishop"
      Bishop.new(color: king.color, position: position)
    when "rook"
      Rook.new(color: king.color, position: position)
    else
      Knight.new(color: king.color, position: position)
    end
  end
end