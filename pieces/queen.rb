require_relative 'slideable'

class Queen < Piece
  include Slideable
  
  def to_s
    " Q "
  end
end
