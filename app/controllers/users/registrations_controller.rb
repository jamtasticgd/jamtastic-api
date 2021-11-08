module Users
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name telegram known_skills])
    end

    def build_resource
      super

      build_known_skills
    end

    def build_known_skills
      known_skills_codes = params[:known_skills] || []
      known_skills = Skill.where(code: known_skills_codes)

      known_skills.each do |known_skill|
        @resource.known_skills.new(skill: known_skill)
      end
    end
  end
end
