require 'zombie_battleground/browser/cards'
require 'zombie_battleground/browser/decks'

class DecksController < ApplicationController
  include ZombieBattleground::Browser::Cards
  include ZombieBattleground::Browser::Decks

  def index; end

  def show
    @cards = []

    @deck = ZombieBattleground::Api.deck(id: params[:id].to_i)
    @deck.cards.each do |simple_card|
      Array.new(simple_card.amount) do
        @cards << all_cards.find { |card| card.name == simple_card.card_name }
      end
    end

    render 'decks/viewer'
  end

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
