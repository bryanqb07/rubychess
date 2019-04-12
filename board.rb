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

  def in_check?(color)
    king_pos = find_king(color)
    enemy_pieces = enemy_pieces(color)
    enemy_pieces.each{ |piece| return true if piece.moves.include?(king_pos) }
    false
  end

  def find_king(color)
    @grid.each do |row|
      row.find { |piece| return piece.pos if piece.color == color && piece.class.name[-4..-1] == "King" }
    end
  end

  def enemy_pieces(color)
    piece_list = []
    @grid.each do |row|
      row.each { |piece| piece_list << piece if piece != @sentinel && piece.color != color }
    end
    piece_list
  end

  def move_piece(start_pos, finish_pos)
    raise "Invalid start pos" if empty?(start_pos)
    raise "Same team" if self[start_pos].color == self[finish_pos].color
    raise "Invalid move" unless self[start_pos].moves.include?(finish_pos)

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
