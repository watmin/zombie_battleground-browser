require 'zombie_battleground/browser/cards'

class CardsController < ApplicationController
  include ZombieBattleground::Browser::Cards

  def index; end

  def show
    @card = all_cards.find do |card|
      card.mould_id == params[:mould_id] &&
        card.version == params[:version]
    end
  end

  def filter
    @filter = params[:filter]
    @criteria = params[:criteria]

    @found = if @filter == 'all'
               all_cards
             else
               all_cards.select { |card| card.send(@filter) == @criteria }
             end

    render 'cards/search'
  end

  def search
    @found = []

    @normalized_terms = nomalize_search_terms
    return if @normalized_terms.blank?

    all_cards.each do |card|
      @normalized_terms.each do |term|
        next unless card.description.match?(term) ||
                    card.flavor_text.match?(term) ||
                    card.name.match?(term) ||
                    card.rank.match?(term) ||
                    card.rarity.match?(term) ||
                    card.set.match?(term) ||
                    card.kind.match?(term) ||
                    card.type.match?(term)

        @found << card
      end
    end
  end

  def nomalize_search_terms
    terms = params[:terms]
    return if terms.nil?

    terms.downcase
        .tr('_', '')
        .gsub(/[^A-Za-z]+/, '_split_')
        .split('_split_')
        .compact
        .reject { |term| term.empty? || term.length < 3 }
        .map { |term| Regexp.new(term, Regexp::IGNORECASE) }
  end
end
