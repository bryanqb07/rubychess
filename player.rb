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
  # @@piece_vals = {
  #   "BlackRook" => 5,
  #   "BlackKnight" => 3,
  #   "BlackBishop" => 3,
  #   "BlackQueen" => 9,
  #   "BlackKing" => 0,
  #   "BlackPawn" => 1,
  #
  #   "WhiteRook" => 5,
  #   "WhiteKnight" => 3,
  #   "WhiteBishop" => 3,
  #   "WhiteQueen" => 9,
  #   "WhiteKing" => 0,
  #   "WhitePawn" => 1,
  #
  #   "NullPiece" => 0
  # }


  def initialize(color,display)
    super(color, display)
    @move_count = 0
  end

  def make_move(board)
    own_movable_pieces = board.same_pieces(color).select{ |piece| piece.valid_moves.length > 0 }
    if @move_count < 5 && !board.in_check?(self.color)
      own_movable_pieces.reject! do |piece|
        piece.class.name[-4..-1] == "King" || piece.pos[1] == 7 || piece.pos[1] == 0
      end
    end

    piece, move = smart_move(own_movable_pieces, board) unless own_movable_pieces.nil?

    # if piece.nil? # make a safe random move if no attacking options
    #   piece, move = safe_random_move(own_movable_pieces, board)
    # end
    if piece.nil? #make completely random move if all pieces in trouble
      piece = own_movable_pieces.sample
      move = piece.valid_moves.sample
    end
    board.move_piece(piece.pos, move)
    @move_count += 1
    display.render
  end

  def net_val(board)
    pieces_val = board.same_pieces(self.color).map { |piece| piece.value }
    opp_pieces_val = board.enemy_pieces(self.color).map { |piece| piece.value }
    pieces_val.reduce(:+) - opp_pieces_val.reduce(:+)
  end

  def smart_move(pieces, board)
    max_gain = 0
    best_piece = nil
    best_move = nil
    pieces.each do |piece|
      piece.valid_moves.each do |move_pos|
        take_val = board[move_pos].value #value of enemy piece at position
        next_board = Board.dup(board)
        next_board.move_piece(piece.pos, move_pos)
        #return pos if checkmate
        return [piece, move_pos] if next_board.game_over?

        #return pos if lower val piece can take higher val ex pawn takes queen
        return [piece, move_pos] if piece.value < take_val

        #if you can take an enemy piece, check if it's safe
        enemies = board.enemy_pieces(self.color)
        if take_val > max_gain
            enemy_moves = enemies.count{ |piece| piece.valid_moves.include?(move_pos)}
            if enemy_moves < 1
                best_piece = piece
                best_move = move_pos
                max_gain = take_val
            end
        #move out of danger if possible
        else
          enemies.select! {|enemy| (enemy.value - piece.value > max_gain) && enemy.valid_moves.include?(piece.pos) }
          if enemies.length > 0
            best_piece = piece
            best_move = piece.valid_moves.sample
            max_gain = enemy.value - piece.value
          end
        end



        #   #check enemies counter-moves
        #   enemies.each do |enem_piece|
        #   enem_piece.valid_moves.each do |enem_move|
        #     lose_val = next_board[enem_move].value
        #     third_board = Board.dup(next_board)
        #     third_board.move_piece(enem_piece.pos, enem_move)
        #     # new_val = net_val(third_board)
        #     #if still a net gain choose the move
        #     if (take_val - lose_val) > max_gain
        #       best_piece = piece
        #       best_move = move_pos
        #       max_gain = take_val - lose_val
        #     end
        #   end
        # end
      end
    end
    [best_piece, best_move]
  end

  def safe_random_move(pieces, board)
    count = 0
    max_count = pieces.length
    piece = nil
    move = nil
    # debugger
    loop do
      piece = pieces.sample
      move = piece.valid_moves.sample
      next_board = Board.dup(board)
      next_board.move_piece(piece.pos, move)
      enemies = next_board.enemy_pieces(self.color).select{|piece| piece.valid_moves.length > 0 }
      break if smart_move(enemies, board).nil? || count >= max_count
      count += 1
    end
    return [piece,move]
  end

end
