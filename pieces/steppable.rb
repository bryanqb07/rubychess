module SteppingPiece

  def moves
    move_list = []
    move_dirs.each do |dx, dy|
      new_pos = [pos[0] + dx, pos[1] + dy]
      if board.valid_pos?(new_pos)
        if board.empty?(new_pos)
          move_list << new_pos
        else
          move_list << new_pos if is_enemy?(new_pos)
        end
      end
    end
    move_list
  end
end
