require_relative 'board'
require_relative 'cursor'
require 'colorize'

class Display

  def initialize
    @board = Board.new
    @cursor = Cursor.new([0,0], @board)
  end

  def tile_color(pos)
    if pos == @cursor.cursor_pos
      return @cursor.selected ? :red : :green
    end
    row, col = pos
    if (row.even? && col.even?) || (row.odd? && col.odd?)
      return :white
    else
      return :black
    end
  end

  def row_builder(row, row_idx)
    col_idx = 0
    print row_idx.to_s + "  "
    row.map do |ele|
        pos = [row_idx, col_idx]
        if(ele.nil?)
          print "   ".colorize(:color => :white, :background => tile_color(pos))
        else
          print ele.to_s.colorize(:color => :blue, :background => tile_color(pos))
        end
        col_idx += 1
    end
    puts ""
  end

  def grid_builder
    puts "    #{(0..7).to_a.join('  ')}"
    row_idx = 0
    @board.grid.map do |row|
      row_builder(row, row_idx)
      row_idx += 1
    end
  end

  def render
    system("clear")
    grid_builder
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
  end

  def play
    while !game_over?
      self.render
      @cursor.get_input
    end
  end

  def game_over?
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  Display.new.play
end
