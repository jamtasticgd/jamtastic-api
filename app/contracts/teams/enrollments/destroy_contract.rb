module Teams
  module Enrollments
    class DestroyContract < ApplicationContract
      params do
        required(:team_id).filled(:string)
        required(:id).filled(:string)
      end
    end
  end
end
