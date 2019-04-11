require_relative 'piece'
require 'byebug'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8)
    make_grid
  end

  def make_grid
    8.times do |row_idx|
      if row_idx < 2 || row_idx > 5
        @grid[row_idx] = piece_row
      else
        @grid[row_idx] = empty_row
      end
    end
    # @grid[0] = piece_row
    # @grid[1] = piece_row
    # @grid[2] = empty_row
    # @grid[3] = empty_row
    # @grid[4] = empty_row
    # @grid[5] = empty_row
    # @grid[6] = piece_row
    # @grid[7] = piece_row
  end

  def move_piece(start_pos, finish_pos)
    raise "Invalid start pos" if self[start_pos].nil?
    raise "Invalid end pos" unless self[finish_pos].nil?
    self[finish_pos] = self[start_pos]
    self[start_pos] = nil
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

  private

  def piece_row
    return [Piece.new] * 8
  end

  def empty_row
    return [nil] * 8
  end
end
