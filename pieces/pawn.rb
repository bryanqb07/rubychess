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

  def moves
    move_list = []
    curr_row, curr_col = pos
    up_one_pos = [curr_row - 1, curr_col] #forward one step
    up_two_pos = [curr_row - 2, curr_col] #forward two steps while on first row
    move_list << up_one_pos if board.empty?(up_one_pos) && curr_row > 0
    move_list << up_two_pos if board.empty?(up_one_pos) && board.empty?(up_two_pos) && curr_row == 6
    right_diag_pos = [curr_row - 1, curr_col + 1] #diagonal attack enemy
    move_list << right_diag_pos if curr_col < 7 && is_enemy?(right_diag_pos)
    left_diag_pos = [curr_row - 1, curr_col - 1] #diagonal attack enemy
    move_list << left_diag_pos if curr_col > 0 && is_enemy?(left_diag_pos)
    move_list
  end
end

class BlackPawn < Pawn
  def color
    "black"
  end

  def symbol
    "\u265F".encode('utf-8')
  end

  def moves
    move_list = []
    curr_row, curr_col = pos
    up_one_pos = [curr_row + 1, curr_col] #forward one step
    up_two_pos = [curr_row + 2, curr_col] #forward two steps while on first row
    move_list << up_one_pos if board.empty?(up_one_pos) && curr_row < 7
    move_list << up_two_pos if board.empty?(up_one_pos) && board.empty?(up_two_pos) && curr_row == 1
    right_diag_pos = [curr_row + 1, curr_col + 1] #diagonal attack enemy
    move_list << right_diag_pos if curr_col < 7 && is_enemy?(right_diag_pos)
    left_diag_pos = [curr_row + 1, curr_col - 1] #diagonal attack enemy
    move_list << left_diag_pos if curr_col > 0 && is_enemy?(left_diag_pos)
    move_list
  end
end
