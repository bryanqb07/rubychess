module Slideable
  DIAGONAL_DIRS = [ [1, 1], [1, -1], [-1, 1], [-1, -1] ]
  HORIZONTAL_DIRS = [ [1, 0], [0, 1], [-1, 0], [0, -1] ]

  def diagonal_dirs
    DIAGONAL_DIRS
  end

  def horizontal_dirs
    HORIZONTAL_DIRS
  end

  def moves
    move_list = []
    move_dirs.each {|dx, dy| move_list.concat(grow_unblocked_moves(dx,dy)) }
    move_list
  end

  def grow_unblocked_moves(dx, dy)
    move_list = []
    curr_x, curr_y = pos
    loop do
      curr_x, curr_y = curr_x + dx, curr_y + dy
      new_pos = [curr_x, curr_y]
      break unless board.valid_pos?(new_pos)
      if new_pos.is_a? NullPiece
        move_list << new_pos
      # LATER ADD CASE FOR ENEMY PIECE
      else
        #pass
      end
    end
    move_list
  end

end
