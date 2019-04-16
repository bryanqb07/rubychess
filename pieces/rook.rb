require_relative 'piece'
require_relative 'slideable'

class Rook < Piece
  include SlidingPiece

  def initialize(position, board)
    super(position, board)
    @value = 5
  end

  def move_dirs
    horizontal_dirs
  end
end

class WhiteRook < Rook
  def color
    "white"
  end

  def symbol
    "\u2656".encode('utf-8')
  end
end

class BlackRook < Rook
  def color
    "black"
  end

  def symbol
    "\u265C".encode('utf-8')
  end
end
