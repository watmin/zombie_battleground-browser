module ZombieBattleground
  module Browser
    module Cards
      def all_cards
        Rails.cache.fetch('all_cards', expires_in: 12.hours) do
          ZombieBattleground::Api.all_cards.to_a
        end
      end
    end
  end
end
