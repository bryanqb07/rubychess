# require_relative 'piece'
require_relative 'pieces.rb'
require 'byebug'

class Board
  attr_accessor :grid
  attr_reader :sentinel

  def initialize(trueGrid = true)
    @grid = Array.new(8)
    @sentinel = NullPiece.instance
    make_grid if trueGrid
  end

  def make_grid
    8.times do |row_idx|
      if row_idx == 0 || row_idx > 6
        @grid[row_idx] = back_row(row_idx)
      elsif row_idx == 1 || row_idx == 6
        @grid[row_idx] = pawn_row(row_idx)
      else
        @grid[row_idx] = empty_row
      end
    end

  end

  def checkmate?(color)

  end

  def in_check?(color)
    king_pos = find_king_pos(color)
    enemy_pieces = enemy_pieces(color)
    enemy_pieces.each{ |piece| return true if piece.moves.include?(king_pos) }
    false
  end

  def find_king_pos(color)
    @grid.flatten.select{|piece| return piece.pos if piece.class.name[-4..-1] == "King" && piece.color == color }
  end

  def enemy_pieces(color)
    @grid.flatten.select{|piece| piece != @sentinel && piece.color != color}
  end

  def move_piece(start_pos, finish_pos)
    raise "Invalid start pos" if empty?(start_pos)
    raise "Same team" if self[start_pos].color == self[finish_pos].color
    raise "Invalid move" unless self[start_pos].valid_moves.include?(finish_pos)

    self[start_pos].pos = finish_pos #update pos of each piece upon valid move
    self[finish_pos] = self[start_pos]
    self[start_pos] = @sentinel
    true
  end

  def move_piece!(start_pos, finish_pos)
    self[start_pos].pos = finish_pos #update pos of each piece upon valid move
    self[finish_pos] = self[start_pos]
    self[start_pos] = @sentinel
    true
  end

  def [] (pos)
    row, col = pos
    @grid[row][col]
  end


  def []= (pos, val)
    row, col = pos
    @grid[row][col] = val
  end

  def valid_pos?(pos)
    pos[0] >= 0 && pos[0] <= 7 && pos[1] >= 0 && pos[1] <= 7
  end

  def empty?(pos)
    self[pos] == @sentinel
  end

  def self.dup(orig_board)
    new_board = Board.new(false)
    8.times{|row_idx| new_board.grid[row_idx] = Array.new(8) }

    orig_board.grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        pos = [row_idx, col_idx]
        if piece.is_a? NullPiece
          # new_board.grid[row_idx][col_idx] = new_board.sentinel
          new_board[pos] = new_board.sentinel
        else
          # new_board.grid[row_idx][col_idx] = new_board.sentinel
          new_board[pos] = piece.class.new(pos, new_board)
        end
      end
    end
    new_board
  end

  private
  # refactoring target
  def back_row(row_idx)
    piece_row = row_idx == 0 ?
    [
      BlackRook.new([0, 0], self),
      BlackKnight.new([0, 1], self),
      BlackBishop.new([0, 2], self),
      BlackQueen.new([0, 3], self),
      BlackKing.new([0, 4], self),
      BlackBishop.new([0, 5], self),
      BlackKnight.new([0, 6], self),
      BlackRook.new([0, 7], self)
  ]: [
      WhiteRook.new([7, 0], self),
      WhiteKnight.new([7, 1], self),
      WhiteBishop.new([7, 2], self),
      WhiteQueen.new([7, 3], self),
      WhiteKing.new([7, 4], self),
      WhiteBishop.new([7, 5], self),
      WhiteKnight.new([7, 6], self),
      WhiteRook.new([7, 7], self)
  ]
  return piece_row
  end

  def pawn_row(row_idx)
    pawn_row = Array.new(8)
    if row_idx == 1
      8.times { |col_idx| pawn_row[col_idx] = BlackPawn.new([1, col_idx], self ) }
    else
      8.times { |col_idx| pawn_row[col_idx] = WhitePawn.new([6, col_idx], self ) }
    end
    return pawn_row;
  end

  def empty_row
    return [@sentinel] * 8
  end
end
