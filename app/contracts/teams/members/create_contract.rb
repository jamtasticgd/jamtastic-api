module Teams
  module Members
    class CreateContract < ApplicationContract
      params do
        required(:team_id).filled(:string)
      end
    end
  end
end
