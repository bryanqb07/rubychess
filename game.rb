require_relative 'display'
require_relative 'player'
require 'byebug'

class Game
  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @players = { "white" => HumanPlayer.new("white", @display),
                 "black" => HumanPlayer.new("black", @display)
                }
    @current_player = @players["white"]
  end


  def play
    debugger
    until @board.game_over?
      notify_players
      sleep(1)
      @current_player.make_move(@board)
      swap_turn!
    end
    @display.render
    swap_turn!
    puts "Checkmate! #{@current_player.color} wins!"
  end

  private

  def notify_players
    king_sym = {"white" => "\u2654".encode('utf-8'), "black" => "\u265A".encode('utf-8')}
    puts "#{@current_player.color} #{king_sym[@current_player.color]} to move"
  end

  def swap_turn!
    @current_player = @current_player == @players["white"] ? @players["black"] : @players["white"]
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
