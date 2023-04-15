class Pin

  attr_reader :identity, :position, :defending_against, :defending_position 

  def initialize(identity, position, defending_against, defending_position)
    @identity = identity
    @position = position
    @defending_against = defending_against
    @defending_position = defending_position
  end
end