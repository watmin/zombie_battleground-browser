class CardsController < ApplicationController
  def index; end

  def all_cards
    Rails.cache.fetch('all_cards', expires_in: 12.hours) do
      ZombieBattleground::Api.all_cards.to_a
    end
  end

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

    remove_invalid_cards
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

    remove_invalid_cards
  end

  def remove_invalid_cards
    return if @found.nil?

    @found.reject! { |card| card.mould_id.to_i > 156 }
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
