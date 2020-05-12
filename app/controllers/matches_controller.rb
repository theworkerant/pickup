class MatchesController < ApplicationController
  before_action :authenticate

  def index
    @recent_matches = Match.where("start_time > ?", Time.now)
    @matches = Match.where("start_time > ?", Time.now)
  end
end
