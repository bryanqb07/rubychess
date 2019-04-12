require 'byebug'

class Player
  attr_reader :color, :display

  def initialize(color, display)
    @color = color
    @display = display
  end

  def make_move(board)
    # if board.move_piece(start_pos, finish_pos)
    #   return
    # else
    #   make_move(board)
    # end
    # move = board.move_piece(start_pos, finish_pos)
    # p move
    # make_move(board) if move.nil?
  end
end

class HumanPlayer < Player

  def initialize(color,display)
    super(color, display)
  end

  def make_move(board)
    start_pos = nil
    finish_pos = nil
    until start_pos != nil && board[start_pos].color == color
      display.render
      start_pos = display.cursor.get_input
    end
    until finish_pos != nil && finish_pos != start_pos
      display.render
      finish_pos = display.cursor.get_input
    end

    board.move_piece(start_pos, finish_pos)
  end

end

class ComputerPlayer < Player

  def initialize(color,display)
    super(color, display)
  end

  def make_move(board)
    start_pos = nil
    finish_pos = nil
    until start_pos != nil && board[start_pos].color == color
      display.render
      start_pos = display.cursor.get_input
    end
    until finish_pos != nil && finish_pos != start_pos
      display.render
      finish_pos = display.cursor.get_input
    end

    board.move_piece(start_pos, finish_pos)
  end

end
