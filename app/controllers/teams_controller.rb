# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :authenticate_user!, only: %w[create destroy]
  contracts create: ::Teams::CreateContract

  def index
    teams = Team.order(:created_at)

    render(json: TeamsSerializer.render(teams), status: :ok)
  end

  def show
    team = Team.find(params[:id])
    team_member = team.team_members.find_by(user: current_user)

    options = {}
    options[:enrollment_id] = team_member.id if team_member.present?
    options[:view] = :owner if team.owner?(current_user)

    render(json: TeamsSerializer.render(team, options), status: :ok)
  end

  def create
    team = CreateTeam.new(user: current_user, params: contract_result.to_h).call

    if team.persisted?
      render(json: TeamsSerializer.render(team), status: :created)
    else
      render(json: Models::ErrorsSerializer.render(team), status: :unprocessable_entity)
    end
  end

  def destroy
    team = current_user.teams.find(params[:id])
    team.destroy!

    head :no_content
  end
end
