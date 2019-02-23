require 'zombie_battleground/browser/cards'
require 'zombie_battleground/browser/decks'

class DecksController < ApplicationController
  include ZombieBattleground::Browser::Cards
  include ZombieBattleground::Browser::Decks

  def index; end

  def show
    @cards = []

    @deck = ZombieBattleground::Api.deck(id: params[:id].to_i)
    @deck_faction = ZombieBattleground::Api.deck_faction(@deck.hero_id)
    @deck.cards.each do |simple_card|
      Array.new(simple_card.amount) do
        @cards << all_cards.find { |card| card.name == simple_card.card_name }
      end
    end

    render 'decks/viewer'
  end

  def show_player_deck
    @cards = []

    @deck = ZombieBattleground::Api.decks(user_id: params[:user_id], deck_id: params[:deck_id].to_i).first
    @deck_faction = ZombieBattleground::Api.deck_faction(@deck.hero_id)
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
