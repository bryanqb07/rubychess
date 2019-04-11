require_relative 'slideable'

class Rook < Piece
  include Slideable

  def to_s
    " R "
  end
end
