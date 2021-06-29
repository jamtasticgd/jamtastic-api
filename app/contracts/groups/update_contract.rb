module Groups
  class UpdateContract < ApplicationContract
    params do
      required(:id).filled(:string)
      required(:member_count).filled(:integer)
    end
  end
end
