require 'zombie_battleground/browser/matches_buffer_manager'
#
matches_buffer_manager = ZombieBattleground::Browser::MatchesBufferManager.new
matches_buffer_manager.warm

Thread.new do
  Rails.application.executor.wrap do
    matches_buffer_manager.start
  end
end
