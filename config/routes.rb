Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'index#index'

  # Cards
  get '/cards', to: 'cards#index'
  get '/cards/search', to: 'cards#search'
  get '/cards/filter/:filter(/:criteria)', to: 'cards#filter'
  get '/cards/show/:mould_id/:version', to: 'cards#show'

  # Decks

  # Matches
end
