require 'singleton'

module ZombieBattleground
  module Browser
    class MatchesBuffer < Array
      include Singleton

      def insert(match)
        @mutex.synchronize do
          if self.size < @max_size
            self.unshift(match)
          else
            self.pop
            self.unshift(match)
          end
        end
      end

      private

      def initialize
        @max_size = 10_000
        @mutex = Mutex.new
      end
    end
  end
end
