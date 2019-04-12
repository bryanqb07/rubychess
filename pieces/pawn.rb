require_relative 'piece'

class Pawn < Piece
  def initialize(position, board)
    super(position, board)
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
