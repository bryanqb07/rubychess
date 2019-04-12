require_relative 'piece'
require_relative 'steppable'

class Knight < Piece
  include SteppingPiece

  def initialize(position, board)
    super(position, board)
  end

  def move_dirs
    [
      [2,1], [1,2], [-1, 2], [-2, 1],
      [-2, -1], [-1, -2], [1, -2], [2, -1]
    ]
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
