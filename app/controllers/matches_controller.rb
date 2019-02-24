require 'zombie_battleground/browser/matches'

class MatchesController < ApplicationController
  include ZombieBattleground::Browser::Matches

  def index
    @matches = buffered_matches.first(48)
  end

  def show
    @match = ZombieBattleground::Api.match(id: params[:match_id].to_i)
  end
end
