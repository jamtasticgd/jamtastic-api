module Teams
  class UpdateContract < ApplicationContract
    params do
      required(:id).filled(:string)
      required(:name).filled(:string)
      required(:description).filled(:string)
      required(:approve_new_members).filled(:bool)
      optional(:needed_skills).array(:string)
    end
  end
end
