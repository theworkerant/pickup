class MatchesController < ApplicationController
  before_action :authenticate

  def index
    @recent_matches = Match.where("start_time <= ?", Time.now)
    @matches = Match.where("start_time > ?", Time.now)
  end

  def new
    @game = Game.find_by(slug: params["game"]) || nil
    @games = Game.all - [@game]
    @match = Match.new(game: @game)
  end

  def create
    @match = Match.create(match_params.merge(host: @current_user))

    if @match.errors.present?
      render "new"
    else
      @match.announce
      redirect_to match_path(@match)
    end
  end

  def show
    @match = Match.where("id = ?", params["id"]).includes(reservations: [:user]).first
  end

  def reserve
    @match = Match.find(params["match_id"])
    @match.reserve(current_user)
    redirect_to match_path(@match)
  end

  def relinquish
    @match = Match.find(params["match_id"])
    @match.relinquish(current_user)
    redirect_to match_path(@match)
  end

  private

  def match_params
    params.require(:match).permit(:game_id, :slots, :start_time, :duration, :description)
  end
end
