# Odin Project Chess

A command line game of chess. Implemented in Ruby.

In an attempt to avoid generating all possible moves and then eliminating the ones that produce check, this implementation employs the following strategy.

1. At the start of each turn, determine which (if any) of opponent's pieces are checking player's king as well as whether player has any pieces that are blocking a check (pins) by starting at the player's king position and walking outward in each possible direction of attack.

2. Treat moves as belonging to two categories: moves from check, and moves in the absence of check. Only generate the relevant moves for the turn.

- Moves from check include: 
  1. moves the king can make to an adjacent square that is not itself under attack, 
  2. defensive moves, where a non-king piece may either capture the opponent's checking piece or hold it back by interrupting the line of attack

  Only king moves are relevant in the case of multiple check. 
  Otherwise both types are.

- Moves in the absence of check include:
  1. moves the king can make (same as above),
  2. moves pins can make (same as above),
  3. moves of non-pins. 

All categories of moves are generated in essentially the same way: check the relevant line segments(s) from one position to another. 

In the case of pins, this is the line between the king and the opponent piece that threatens check (including opponent, excluding king). 

In the case of defensive moves, these are the lines of attack from the opponent piece, and the squares between the king and the opponent piece (including opponent, excluding king). 

In the case of non-pins, these are the lines from the piece that are consistent with the rules of its movement (eg. diagonal in the case of bishops, orthogonal in the case of rooks, etc.)

