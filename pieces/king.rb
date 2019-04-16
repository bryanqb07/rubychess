require_relative 'piece'
require_relative 'steppable'

class King < Piece
  include SteppingPiece

  def initialize(position, board)
    super(position, board)
    @value = 0
  end

  def move_dirs
    king_steps
  end

end

class WhiteKing < King
  def color
    "white"
  end

  def symbol
    "\u2654".encode('utf-8')
  end
end

class BlackKing < King
  def color
    "black"
  end

  def symbol
    "\u265A".encode('utf-8')
  end
end
