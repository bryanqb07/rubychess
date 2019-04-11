class Piece
  attr_reader :board
  attr_accessor :pos

  def initialize(pos, board)
    @pos = pos
    @board = board
    @color = color
  end

  def to_s
    " O "
  end
end
