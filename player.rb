require 'byebug'

class Player
  attr_reader :color, :display

  def initialize(color, display)
    @color = color
    @display = display
  end

  def make_move(board)

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
    display.render
  end

end

class ComputerPlayer < Player
  attr_reader :depth

  def initialize(color,display)
    super(color, display)
    @move_count = 0
    @depth = 6
  end

  def make_move(board)
    own_movable_pieces = board.same_pieces(color).select{ |piece| piece.valid_moves.length > 0 }

    piece, move = smart_move(own_movable_pieces, board) unless own_movable_pieces.nil?

    if piece.nil? #make completely random move if all pieces in trouble
      piece = own_movable_pieces.sample
      move = piece.valid_moves.sample
    end
    board.move_piece(piece.pos, move)
    @move_count += 1
    display.render
  end

  def net_val(board)
    if self.color == "white"
      return 999999 if board.checkmate?("black")
    else
      return -999999 if board.checkmate?("white")
    end
    pieces_val = board.same_pieces(self.color).map { |piece| piece.value }
    opp_pieces_val = board.enemy_pieces(self.color).map { |piece| piece.value }
    pieces_val.reduce(:+) - opp_pieces_val.reduce(:+)
  end

  def smart_move(pieces, board)
    best_piece = nil
    best_move = nil
    max_gain = 0

    pieces.each do |piece|
      piece.valid_moves.each do |move|
        best = mini_max(board, piece, move, self.depth, false)
        return [piece, move] if best > 900000 # break if checkmate condition
        if best > max_gain
          best_piece = piece
          best_move = move
          max_gain = best
        end
      end
    end
    return [best_piece, best_move]
  end

  def mini_max(board, piece, move, depth, maximizing_player)
    # debugger
    new_board = Board.dup(board)
    new_board.move_piece(piece.pos, move)

    if depth == 0 || new_board.game_over?
      return net_val(new_board)
    end

    if maximizing_player
      max_eval = -999999
      pieces = new_board.same_pieces(self.color).select {|piece| piece.valid_moves.length > 0 }
      pieces.each do |next_piece|
        next_piece.valid_moves.each do |next_move|
          eval = mini_max(new_board, next_piece, next_move, depth - 1, false)
          max_eval = [max_eval, eval].max
        end
      end
      return max_eval
    else
      min_eval = 9999999
      pieces = new_board.enemy_pieces(self.color).select {|piece| piece.valid_moves.length > 0 }
      pieces.each do |next_piece|
        next_piece.valid_moves.each do |next_move|
          min_eval = [min_eval, mini_max(new_board, next_piece, next_move, depth - 1, true)].min
        end
      end
      return min_eval
    end
  end

end
