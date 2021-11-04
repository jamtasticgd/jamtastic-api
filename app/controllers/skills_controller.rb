# frozen_string_literal: true

class SkillsController < ApplicationController
  def index
    skills = Skill.all

    render json: SkillsSerializer.render(skills)
  end
end
