# Odin Project Chess

Am OOP command line game of chess. Implemented in Ruby.

In an attempt to avoid generating all possible moves and then eliminating the ones that produce check, this implementation employs the following strategy.

1. Determine which (if any) of opponent's pieces are checking player's king as well as whether player has any potential pins by starting at the player's king position and walking outward in each possible direction of attack.

2. Generate moves depending on the check situation (no checks, single check, multiple checks)

- Moves from single check include
  1. moves the king can make to an adjacent square that is not itself under attack, 
  2. defensive moves, where a non-king piece may either capture the opponent's checking piece or hold it back by interrupting the line of attack

- Whereas only the king may move when there are multiple checks.

- Moves in the absence of check include:
  1. moves the king can make (same as above)
  2. moves pins can make
  3. moves of non-pins

Move generation is handled by the relevant move generator class. 