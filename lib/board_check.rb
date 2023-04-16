module BoardCheck
  def on_board?(converted_move)
    converted_move[0].between?(0, 7) && converted_move[1].between?(0, 7)
  end
end