require_relative 'board'
require_relative 'cursor'
require 'colorize'

class Display
  attr_reader :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([4,4], @board)
  end

  def tile_color(pos)
    if pos == @cursor.cursor_pos
      return @cursor.selected ? :red : :green
    end
    row, col = pos
    if (row.even? && col.even?) || (row.odd? && col.odd?)
      return :yellow
    else
      return :blue
    end
  end

  def row_builder(row, row_idx)
    col_idx = 0
    #REVERSE ON PRODUCTION
    print (7- row_idx).to_s + "  "
    #debugging purposes
    # print row_idx.to_s + "  "
    row.map do |piece|
        pos = [row_idx, col_idx]
        background_color = tile_color(pos)
        print " ".colorize(:background => background_color)
        print piece.symbol.colorize(:background => background_color)
        print "  ".colorize(:background => background_color)
        col_idx += 1
    end
    puts ""
  end

  def grid_builder
    #for debugging purposes use col numbers
    # puts "    #{(''..7).to_a.join('   ')}"
    # ADD BACK LATER
    puts "    #{('A'..'H').to_a.join('   ')}"
    row_idx = 0
    @board.grid.map do |row|
      row_builder(row, row_idx)
      row_idx += 1
    end
  end

  def render
    system("clear")
    grid_builder
    puts ""
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
  end



  def game_over?
    false
  end
end
