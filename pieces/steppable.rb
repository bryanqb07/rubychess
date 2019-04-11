module Steppable
  def moves
    move_list = []
    move_diffs.each do |dx, dy|
      new_pos = [pos[0] + dx, pos[1] + dy]
      return unless board.valid_pos?(new_pos)
    end
  end
end
