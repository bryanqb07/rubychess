require_relative 'piece'
require_relative 'slideable'

class Bishop < Piece
  include SlidingPiece

  def initialize(position, board)
    super(position, board)
    @value = 3
  end

  def move_dirs
    diagonal_dirs
  end

end

class WhiteBishop < Bishop
  def color
    "white"
  end

  def symbol
    "\u2657".encode('utf-8')
  end
end

class BlackBishop < Bishop
  def color
    "black"
  end

  def symbol
    "\u265D".encode('utf-8')
  end
end
