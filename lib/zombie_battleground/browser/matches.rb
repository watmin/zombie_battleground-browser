module ZombieBattleground
  module Browser
    module Matches
      def all_matches
        Rails.cache.fetch('all_matches', expires_in: 15.minutes) do
          ZombieBattleground::Api.all_matches.to_a.uniq { |match| match.id }
        end
      end
    end
  end
end
