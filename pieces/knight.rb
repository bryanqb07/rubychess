require_relative 'piece'
require_relative 'steppable'

class Knight < Piece
  include Steppable

  def initialize(position, board)
    super(position, board)
  end

  def to_s
    " N "
  end
end

class WhiteKnight < Knight
  def color
    "white"
  end

  def symbol
    "\u2658".encode('utf-8')
  end
end

class BlackKnight < Knight
  def color
    "black"
  end

  def symbol
    "\u265E".encode('utf-8')
  end
end
