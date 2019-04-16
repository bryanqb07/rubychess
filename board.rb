# require_relative 'piece'
require_relative 'pieces.rb'
require 'byebug'

class Board
  attr_accessor :grid, :pieces
  attr_reader :sentinel

  def initialize(trueGrid = true)
    @grid = Array.new(8)
    @sentinel = NullPiece.instance
    @pieces = []
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

  #doesnt account for stalement
  def checkmate?(color)
    own_pieces = same_pieces(color)
    own_pieces.each{ |piece| return false if piece.valid_moves.length > 0 }
    true
  end

  def in_check?(color)
    king_pos = find_king_pos(color)
    enemy_pieces = enemy_pieces(color)
    enemy_pieces.each{ |piece| return true if piece.moves.include?(king_pos) }
    false
  end

  def same_pieces(color)
    @pieces.select{|piece| piece != @sentinel && piece.color == color }
  end

  def find_king_pos(color)
    @pieces.select{|piece| return piece.pos if piece.class.name[-4..-1] == "King" && piece.color == color }
  end

  def enemy_pieces(color)
    @pieces.select{|piece| piece != @sentinel && piece.color != color}
  end

  def move_piece(start_pos, finish_pos)
    raise "Invalid start pos" if empty?(start_pos)
    raise "Same team" if self[start_pos].color == self[finish_pos].color
    raise "Invalid move piece: #{self[start_pos]} start: #{start_pos} end: #{finish_pos}" unless self[start_pos].valid_moves.include?(finish_pos)

    unless empty?(finish_pos)
      @pieces.delete(self[finish_pos]) #remove captured piece from piece list
    end

    self[start_pos].pos = finish_pos #update pos of each piece upon valid move

    # check for pawn promotion
    if self[start_pos].class.name[-4..-1] == "Pawn" && (finish_pos[0] == 0 || finish_pos[0] == 7 )
      self[start_pos] = promote!(self[start_pos])
    end

    self[finish_pos] = self[start_pos]
    self[start_pos] = @sentinel
    true
  end

  def promote!(pawn) #promotes pawn to queen
    new_queen = pawn.color == "white" ? WhiteQueen.new(pawn.pos, self) : BlackQueen.new(pawn.pos, self)
    idx = @pieces.delete(pawn)
    @pieces.push(new_queen)
    new_queen
  end

  def move_piece!(start_pos, finish_pos)
    unless empty?(finish_pos)
      @pieces.delete(self[finish_pos]) #remove captured piece from piece list
    end

    self[start_pos].pos = finish_pos #update pos of each piece upon valid move

    # check for pawn promotion
    if self[start_pos].class.name[-4..-1] == "Pawn" && (finish_pos[0] == 0 || finish_pos[0] == 7 )
      self[start_pos] = promote!(self[start_pos])
    end

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
          new_board[pos] = new_board.sentinel
        else
          new_piece = piece.class.new(pos, new_board)
          new_board[pos] = new_piece
          new_board.pieces.push(new_piece)
        end
      end
    end
    new_board
  end

  # def stalemale?
  #   @pieces.length < 3 ||
  # end

  def game_over?
    checkmate?("white") || checkmate?("black")
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
  @pieces.concat(piece_row)
  return piece_row
  end

  def pawn_row(row_idx)
    pawn_row = row_idx == 1 ?
    ( (0..7).to_a.map { |col_idx|  BlackPawn.new([1, col_idx], self ) } )
    : ( (0..7).to_a.map { |col_idx| WhitePawn.new([6, col_idx], self ) } )

    @pieces.concat(pawn_row)
    return pawn_row;
  end

  def empty_row
    return [@sentinel] * 8
  end
end
