require_relative 'piece'
require_relative 'steppable'

class Knight < Piece
  include SteppingPiece

  def initialize(position, board)
    super(position, board)
    @value = 3
  end

  def move_dirs
    knight_steps
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
