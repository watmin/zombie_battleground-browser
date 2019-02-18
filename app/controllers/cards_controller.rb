class CardsController < ApplicationController
  def index; end

  def show
    @card = ZombieBattleground::Api.card(mould_id: params[:mould_id], version: params[:version])
  end

  def filter
    @filter = params[:filter]
    @criteria = params[:criteria]

    if @filter == 'all'
      @found = ZombieBattleground::Api.all_cards.to_a
    else
      @found = ZombieBattleground::Api.send("cards_by_#{@filter}", @criteria)
    end

    render 'cards/search'
  end

  def search
    @found = []

    @normalized_terms = nomalize_search_terms
    return if @normalized_terms.blank?

    ZombieBattleground::Api.all_cards do |card|
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
