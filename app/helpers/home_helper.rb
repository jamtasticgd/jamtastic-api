module HomeHelper
  # Public: Returns how many non-unique members we have on our groups.
  #
  # Returns an Integer value.
  def members_count
    Group.pluck(:member_count).reduce(:+)
  end

  # Public: Returns how many game jams event we were involved.
  #
  # Returns an Integer value.
  def game_jams_count
    5
  end

  # Public: Returns how many games were produced on the game jams we were involved.
  #
  # Returns an Integer value.
  def games_count
    83
  end
end
