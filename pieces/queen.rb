require_relative 'piece'
require_relative 'slideable'

class Queen < Piece
  include Slideable

  def initialize(position, board)
    super(position, board)
  end

  def to_s
    " Q "
  end

  def move_dirs
    diagonal_dirs.concat(horizontal_dirs)
  end
end

class WhiteQueen < Queen
  def color
    "white"
  end

  def symbol
    "\u2655".encode('utf-8')
  end
end

class BlackQueen < Queen
  def color
    "black"
  end

  def symbol
    "\u265B".encode('utf-8')
  end
end
