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
    display.render
  end

end

class ComputerPlayer < Player
  @@piece_vals = {
    "BlackRook" => 5,
    "BlackKnight" => 3,
    "BlackBishop" => 3,
    "BlackQueen" => 9,
    "BlackKing" => 0,
    "BlackPawn" => 1,

    "WhiteRook" => 5,
    "WhiteKnight" => 3,
    "WhiteBishop" => 3,
    "WhiteQueen" => 9,
    "WhiteKing" => 0,
    "WhitePawn" => 1,

    "NullPiece" => 0
  }


  def initialize(color,display)
    super(color, display)
  end

  def make_move(board)
    own_movable_pieces = board.same_pieces(color).select{ |piece| piece.valid_moves.length > 0 }
    piece, move = smart_move(own_movable_pieces, board)
    if piece.nil?
      piece = own_movable_pieces.sample
      move = piece.valid_moves.sample
    end
    board.move_piece(piece.pos, move)
    display.render
  end

  def smart_move(pieces, board)
    cap_diff = 0
    start_piece = nil
    best_pos = nil
    #checkmate
    # debugger
    pieces.each do |piece|
      piece.valid_moves.each do |move_pos|
        target_piece = board[move_pos].class.name
        if @@piece_vals[piece.class.name] < @@piece_vals[target_piece]
          start_piece = piece
          best_pos = move_pos
        end
        test_board = Board.dup(board)
        test_board.move_piece(piece.pos, move_pos)
        return [piece, move_pos] if test_board.game_over?
      end
    end
    [start_piece, best_pos]
  end

end
