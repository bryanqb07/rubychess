require_relative 'steppable'

class Knight < Piece
  include Steppable
  
  def to_s
    " N "
  end
end
