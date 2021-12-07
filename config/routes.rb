Rails.application.routes.draw do
  # - /api/v1/artists
  # - /api/v1/artists/:id/albums
  # - /api/v1/albums/:id/songs
  # - /api/v1/genres/:genre_name/random_song

  namespace :api do
    namespace :v1 do
      resources :artists, only: %i[index show] do
        resources :albums, only: [:index]
      end
      resources :albums, only: [:show] do
        resources :songs, only: [:index]
      end
      resources :genres do
        collection do
          get ':genre_name/random_song', to: 'songs#random_song'
        end
      end
    end
  end
end
