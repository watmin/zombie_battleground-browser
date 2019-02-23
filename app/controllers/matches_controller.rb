require 'zombie_battleground/browser/matches'

class MatchesController < ApplicationController
  include ZombieBattleground::Browser::Matches

  def index
    @created = all_matches.sort { |a, b| b.created_at <=> a.created_at }.first(12)
    @updated = all_matches.sort { |a, b| b.updated_at <=> a.updated_at }.first(12)
    @ended = all_matches.sort { |a, b| b.updated_at <=> a.updated_at }
                        .select { |match| match.status == 'Ended' }.first(12)
  end

  def show
    @match = ZombieBattleground::Api.match(id: params[:match_id].to_i)
  end
end
