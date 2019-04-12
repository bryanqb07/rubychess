class Piece
  attr_reader :board
  attr_accessor :pos

  def initialize(pos, board)
    @pos = pos
    @board = board
  end

  def is_enemy?(pos)
    !board.empty?(pos) && board[pos].color != self.color
  end

  def color
  end

end
