class Api::V1::SongsController < ApplicationController
  # - /api/v1/albums/:id/songs
  def index
    @album = Album.find_by(id: params[:album_id])
    if @album.nil?
      render json: { error: "Not Found Album ID: #{params[:id]}" }, status: 400
    else
      @songs = @album.songs
      render json: @songs, root: 'data', each_serializer: Api::V1::SongSerializer, adapter: :json, status: :ok
    end
  end

  # - /api/v1/genres/:genre_name/random_song
  def random_song
    artists = Artist.where('cast(genres AS VARCHAR) LIKE ?', "%\"#{params[:genre_name]}\"%")
    artist = artists.sample
    @song = artist.albums.sample.songs.sample
    render json: @song, root: 'data', adapter: :json, status: :ok
  end
end
