require_relative 'piece'
require_relative 'steppable'

class King < Piece
  include Steppable

  def initialize(position, board)
    super(position, board)
  end

  def to_s
    " K "
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
