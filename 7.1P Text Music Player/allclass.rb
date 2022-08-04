module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
	attr_accessor :title, :artist, :genre, :tracks

	def initialize (title, artist, genre, tracks)
		# insert lines here
		@title = title
		@artist = artist
		@genre = genre
		@tracks = tracks
	end
end

class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end
