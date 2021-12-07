require 'yaml'
require 'rspotify'

desc 'Load data from YAML files, Fetch data from Spotify API and save to database'
task load_data: :environment do
  load_artists
end

# load yaml file
def load_yaml
  artists_yaml = YAML.safe_load(File.read('lib/artists.yml'))
  p 'Loaded artists.yml file'
  artists_yaml['artists']
end

# fetch data from Spotify API
def load_artists
  artists_list = load_yaml
  artists_list.each do |artist|
    artist_data = RSpotify::Artist.search(artist.to_s).first
    print "Fetching data for \"#{artist_data.name}\"\n"
    sleep 0.3
    create_artist(artist_data) unless artist_data.nil?
  end
end

# create artist record
def create_artist(artist)
  artist_record = Artist.create({
                                  name: artist.name, image: artist.images[0]['url'],
                                  genres: artist.genres, popularity: artist.popularity,
                                  spotify_url: artist.external_urls['spotify'],
                                  spotify_id: artist.id
                                })
  artist_record.save!
  return if artist.albums.nil?

  artist.albums.each do |album|
    print "Fetching data for \"#{album.name}\" by \"#{artist.name}\"\n"
    create_album(album, artist_record.id)
  end
end

# create album record
def create_album(album, artist_id)
  album_record = Album.create({
                                name: album.name, image: album.images[0],
                                total_tracks: album.total_tracks, spotify_url: album.external_urls['spotify'],
                                spotify_id: album.id, artist_id: artist_id
                              })
  album_record.save!
  return if album.tracks.nil?

  album.tracks.each do |song|
    print "Fetching data for \"#{song.name}\" from \"#{album.name}\" by \"#{album.artists[0].name}\"\n"
    create_songs(song, album_record.id)
  end
end

# create song record
def create_songs(song, album_id)
  song_record = Song.create({
                              name: song.name,
                              duration_ms: song.duration_ms,
                              explicit: song.explicit || false,
                              preview_url: song.preview_url,
                              spotify_url: song.external_urls['spotify'],
                              spotify_id: song.id,
                              album_id: album_id
                            })
  song_record.save!
end
