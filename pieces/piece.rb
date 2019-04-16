class Piece
  attr_reader :board, :value
  attr_accessor :pos

  def initialize(pos, board)
    @pos = pos
    @board = board
    @value = 0
  end

  def is_enemy?(pos)
    !board.empty?(pos) && board[pos].color != self.color
  end

  def color
  end

  def valid_moves
    moves.reject{ |pos| move_into_check?(pos) }
  end

  def moves
    []
  end

  def move_into_check?(end_pos)
    new_board = Board.dup(board)
    new_board.move_piece!(self.pos, end_pos)
    new_board.in_check?(self.color)
  end

end
