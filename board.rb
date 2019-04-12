# require_relative 'piece'
require_relative 'pieces.rb'
require 'byebug'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8)
    @sentinel = NullPiece.instance
    make_grid
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

  def move_piece(start_pos, finish_pos)
    raise "Invalid start pos" if empty?(start_pos)
    raise "Same team" if self[start_pos].color == self[finish_pos].color

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

  private

  def back_row(row_idx)
    piece_row = row_idx == 0 ? [
      WhiteRook.new([row_idx, 0], self),
      WhiteKnight.new([row_idx, 1], self),
      WhiteBishop.new([row_idx, 2], self),
      WhiteKing.new([row_idx, 3], self),
      WhiteQueen.new([row_idx, 4], self),
      WhiteBishop.new([row_idx, 5], self),
      WhiteKnight.new([row_idx, 6], self),
      WhiteRook.new([row_idx, 7], self)
    ] : [
      BlackRook.new([row_idx, 0], self),
      BlackKnight.new([row_idx, 1], self),
      BlackBishop.new([row_idx, 2], self),
      BlackKing.new([row_idx, 3], self),
      BlackQueen.new([row_idx, 4], self),
      BlackBishop.new([row_idx, 5], self),
      BlackKnight.new([row_idx, 6], self),
      BlackRook.new([row_idx, 7], self)
  ]
  return piece_row
  end

  def pawn_row(row_idx)
    pawn_row = Array.new(8)
    # classType = row_idx == 1
    if row_idx == 1
      8.times { |col_idx| pawn_row[col_idx] = WhitePawn.new([1, col_idx], self ) }
    else
      8.times { |col_idx| pawn_row[col_idx] = BlackPawn.new([6, col_idx], self ) }
    end
    return pawn_row;
  end

  def empty_row
    return [@sentinel] * 8
  end
end
