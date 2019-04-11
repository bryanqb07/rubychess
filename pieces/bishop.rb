require_relative 'slideable'

class Bishop < Piece
  include Slideable
  
  def to_s
    " B "
  end
end
