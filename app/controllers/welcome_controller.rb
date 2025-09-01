class WelcomeController < ActionController::Base
  def index
    # Generate random background colors
    colors = [
      '#1e3c72', '#2a5298', '#667eea', '#764ba2', '#f093fb',
      '#f5576c', '#4facfe', '#00f2fe', '#43e97b', '#38f9d7',
      '#ffecd2', '#fcb69f', '#a8edea', '#fed6e3', '#d299c2',
      '#ffd89b', '#19547b', '#ff9a9e', '#fecfef', '#fecfef'
    ]
    
    @background_color = colors.sample
    @secondary_color = colors.sample
    
    # Ensure colors are different
    @secondary_color = colors.sample while @secondary_color == @background_color
  end
end