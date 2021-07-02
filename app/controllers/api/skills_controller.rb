# frozen_string_literal: true

module Api
  class SkillsController < Api::ApplicationController
    def index
      skills = Skill.all

      render json: SkillsSerializer.render(skills)
    end
  end
end
