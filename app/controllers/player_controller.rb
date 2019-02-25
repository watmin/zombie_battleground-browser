class PlayerController < ApplicationController
  def index
    @player_id = params[:player_id]
    @decks = ZombieBattleground::Api.decks(user_id: params[:player_id])
    @matches = ZombieBattleground::Api.matches_for_player(params[:player_id])
  end
end
