require_relative 'steppable'

class King < Piece
  include Steppable

  def to_s
    " K "
  end
end
