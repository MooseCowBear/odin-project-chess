class Pin

  attr_reader :identity, :position, :defending_position 
  attr_accessor :defending_against

  def initialize(identity, position, defending_position)
    @identity = identity
    @position = position
    @defending_against = nil
    @defending_position = defending_position
  end

  def update_defense(opponent_pos)
    self.defending_against = opponent_pos 
  end
end