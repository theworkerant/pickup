class MatchesController < ApplicationController
  before_action :authenticate

  def index
    @recent_matches = Match.where("start_time <= ?", Time.now)
    @matches = Match.where("start_time > ?", Time.now)
  end

  def new
    @game = Game.find_by(slug: params["game"]) || nil
    @games = Game.all
    @match = Match.new(game: @game)
  end

  def create
    @match = Match.create(match_params.merge(host: @current_user))

    if @match.errors.present?
      render "new"
    else
      @match.announce
      redirect_to matches_path(@match)
    end
  end

  private

  def match_params
    params.require(:match).permit(:game_id, :slots, :start_time, :duration, :description)
  end
end
