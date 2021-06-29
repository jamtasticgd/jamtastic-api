module Companies
  class CreateContract < ApplicationContract
    params do
      required(:name).filled(:string)
      optional(:email).filled(:string)
      optional(:facebook).filled(:string)
      optional(:twitter).filled(:string)
      optional(:url).filled(:string)
      optional(:logo).filled(:string)
    end
  end
end
