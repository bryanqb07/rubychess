require_relative 'piece'
require_relative 'slideable'

class Rook < Piece
  include Slideable

  def initialize(position, board)
    super(position, board)
  end

  def to_s
    " R "
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
