require 'zombie_battleground/browser/matches_buffer'

module ZombieBattleground
  module Browser
    class MatchesBufferManager
      def warm
        Rails.logger.info("[#{self.class.name}] Warming the matches buffer")
        @matches_count = ZombieBattleground::Api.matches_request(limit: 1).total

        ZombieBattleground::Api.all_matches do |match|
          ZombieBattleground::Browser::MatchesBuffer.instance.insert(match)
        end
      end

      def start
        Rails.logger.info("[#{self.class.name}] Starting the matches buffer manager")

        loop do
          page = (@matches_count / 100) - 1

          loop do
            Rails.logger.info("[#{self.class.name}] Fetching latest matches changes")
            page += 1
            response = ZombieBattleground::Api.matches_request(page: page)
            update_buffer(response)
            break if response.matches.size < 100
          end

          sleep 60 # check for updates once a minute
        rescue StandardError => e
          Rails.logger.error("Failed to fetch match data: #{e.class} #{e.message}")
          e.backtrace.messages.each { |message| Rails.logger.warn("\t#{message}") }
          sleep 60
          retry
        end
      end

      private

      def update_buffer(response)
        @matches_count = response.total

        response.matches.each do |match|
          present = ZombieBattleground::Browser::MatchesBuffer.instance.find do |buffered|
            buffered.id == match.id
          end

          next unless present.nil?
          ZombieBattleground::Browser::MatchesBuffer.instance.insert(match)
        end
      end
    end
  end
end
