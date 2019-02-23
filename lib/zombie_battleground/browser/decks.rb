module ZombieBattleground
  module Browser
    module Decks
      def all_decks
        Rails.cache.fetch('all_decks', expires_in: 30.minutes) do
          ZombieBattleground::Api.all_decks.to_a
        end
      end
    end
  end
end
