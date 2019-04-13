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
    if piece.nil? # make a random move
      piece = own_movable_pieces.sample
      move = piece.valid_moves.sample
    end
    board.move_piece(piece.pos, move)
    display.render
  end

  def smart_move(pieces, board)
    take_val = 0
    lose_val = 0
    net_val = 0
    start_piece = nil
    best_pos = nil

    pieces.each do |piece|
      piece.valid_moves.each do |move_pos|
        attack_val = @@piece_vals[piece.class.name]
        target_piece = board[move_pos].class.name
        take_val = @@piece_vals[target_piece]
        if take_val > 0 #if enemy not null piece
          if attack_val < take_val #for ex pawn vs queen, pawn auto takes
            start_piece = piece
            best_pos = move_pos
          else #a greater piece can take lesser piece if no danger
            next_board = Board.dup(board)
            next_board.move_piece(piece.pos, move_pos)
            #change later to make more general
            enemy_pieces = next_board.enemy_pieces(self.color)
            enemies = enemy_pieces.select{ |piece| piece.valid_moves.include?(move_pos) }
            if enemies.length < 1
              start_piece = piece
              best_pos = move_pos
            end
          end
        end
        test_board = Board.dup(board)
        test_board.move_piece(piece.pos, move_pos)
        return [piece, move_pos] if test_board.game_over?
      end
    end
    [start_piece, best_pos]
  end

end
