module SteppingPiece
  KING_STEPS = [
    [1, 1], [1, -1], [-1, 1], [-1, -1], #diagonal_dirs
    [1, 0], [0, 1], [-1, 0], [0, -1] #horizontal_dirs
  ]

  KNIGHT_STEPS =  [
        [2,1], [1,2], [-1, 2], [-2, 1],
        [-2, -1], [-1, -2], [1, -2], [2, -1]
      ]

  def king_steps
    KING_STEPS
  end

  def knight_steps
    KNIGHT_STEPS
  end

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
