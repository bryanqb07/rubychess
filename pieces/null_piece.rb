require_relative 'piece'

require 'singleton'

class NullPiece < Piece
  include Singleton

  def initialize
    @value = 0
  end

  def symbol
    " "
  end
end
