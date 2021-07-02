module Teams
  class CreateContract < ApplicationContract
    params do
      required(:name).filled(:string)
      required(:description).filled(:string)
      required(:approve_new_members).filled(:bool)
      optional(:needed_skills).array(:string)
    end
  end
end
