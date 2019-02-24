require 'zombie_battleground/browser/matches_buffer'

module ZombieBattleground
  module Browser
    module Matches
      def all_matches
        Rails.cache.fetch('all_matches', expires_in: 15.minutes) do
          ZombieBattleground::Api.all_matches.to_a.uniq { |match| match.id }
        end
      end

      def buffered_matches
        ZombieBattleground::Browser::MatchesBuffer.instance
      end
    end
  end
end
