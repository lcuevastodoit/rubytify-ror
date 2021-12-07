class Api::V1::ArtistsController < ApplicationController
  # - /api/v1/artists
  def index
    @artists = Artist.all.order(popularity: :desc)
    render json: @artists, root: 'data', each_serializer: Api::V1::ArtistSerializer, adapter: :json, status: :ok
  end


end
