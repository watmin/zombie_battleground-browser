require 'zombie_battleground/browser/cards'

Class.new do
  include ZombieBattleground::Browser::Cards

  def initialize
    Rails.logger.info('[cards_cache_warm.rb] Warming Cards cache')
    all_cards
  end
end.new
