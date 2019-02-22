require 'zombie_battleground/browser/cards'

class DecksController < ApplicationController
  include ZombieBattleground::Browser::Cards

  def index; end

  def builder; end

  def builder_from_deck_id
    @cards = []

    @deck = ZombieBattleground::Api.deck(id: params[:id].to_i)
    @deck.cards.each do |simple_card|
      Array.new(simple_card.amount) do
        @cards << all_cards.find { |card| card.name == simple_card.card_name }
      end
    end

    render 'decks/builder'
  end
end
