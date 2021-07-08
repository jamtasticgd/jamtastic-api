module Teams
  module Enrollments
    module Approvals
      class CreateContract < ApplicationContract
        params do
          required(:team_id).filled(:string)
          required(:enrollment_id).filled(:string)
        end
      end
    end
  end
end
