# frozen_string_literal: true

module Api
  class SkillsController < ApplicationController
    def index
      skills = Skill.all

      render json: SkillBlueprint.render_as_json(skills)
    end
  end
end