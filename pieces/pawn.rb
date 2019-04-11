require_relative 'piece'

class Pawn < Piece
  def initialize(position, board)
    super(position, board)
  end

  def to_s
    " P "
  end
end


class WhitePawn < Pawn
  def color
    "white"
  end

  def symbol
    "\u2659".encode('utf-8')
  end
end

class BlackPawn < Pawn
  def color
    "black"
  end

  def symbol
    "\u265F".encode('utf-8')
  end
end
