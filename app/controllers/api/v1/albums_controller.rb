class Api::V1::AlbumsController < ApplicationController
  # - /api/v1/artists/:id/albums
  def index
    @artist = Artist.find_by(id: params[:artist_id])
    if @artist.nil?
      render json: { error: "Not Found Artist ID: #{params[:id]}" }, status: 400
    else
      @albums = @artist.albums
      render json: @albums, root: 'data', each_serializer: Api::V1::AlbumSerializer, adapter: :json, status: :ok
    end
  end
end
