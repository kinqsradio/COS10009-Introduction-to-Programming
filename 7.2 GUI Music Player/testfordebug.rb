require 'rubygems'
require 'gosu'
require './input_functions'

TOP_COLOR = Gosu::Color::WHITE #Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color::WHITE #Gosu::Color.new(0xFF1D4DB5)

module ZOrder
    BACKGROUND, PLAYER, UI = *0..2
end

module Genre
    POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Hip-hop', 'Rock', 'Jazz']

class ArtWork
   attr_accessor :bmp
   def initialize (file)
       @bmp = Gosu::Image.new(file)
   end
end

class Track
    attr_accessor :track_iD, :name, :location
    def initialize (track_iD, name, location)
        @track_iD = track_iD
        @name = name
        @location = location
    end
end
  
class Album
    attr_accessor :album_iD, :title, :artist, :artwork, :genre, :tracks
    def initialize (album_iD, title, artist, artwork, genre, tracks)
        @album_iD = album_iD
        @title = title
        @artist = artist
        @artwork = artwork
        @genre = genre
        @tracks = tracks
    end
end

class Song
   attr_accessor :song
   def initialize (file)
       @song = Gosu::Song.new(file)
   end
end

class MusicPlayerMain < Gosu::Window
    def initialize
        super 800, 600
        self.caption = "Music Player"
        @locs = [60,60]
        @font = Gosu::Font.new(25)

        ##### 
        # -> Necessary for update functions <-
        @album_global = 0
        @track_global = 0
        #####
    end

    def load_album()
        def read_track (music_file, trackiD)
            track_iD = trackiD
            name = music_file.gets
            location = music_file.gets.chomp
            track = Track.new(track_iD, name, location)
            return track
        end

        def read_tracks(music_file)
            count = music_file.gets.to_i
            tracks = Array.new()
            i = 0
            while i < count
                track = read_track(music_file, i+1)
                tracks << track
                i+=1
            end
            return tracks
        end

        def read_album(music_file, i)
            album_iD = i
            title = music_file.gets.chomp
            artist = music_file.gets
            artwork = music_file.gets.chomp
            genre = music_file.gets.to_i
            tracks = read_tracks(music_file)
            album = Album.new(album_iD, title, artist, artwork, genre, tracks)
            return album
        end

        def read_albums(music_file)
            count = music_file.gets.to_i
            albums = Array.new()
            i = 0
            while i < count
                album = read_album(music_file, i+1)
                albums << album
                i+=1
            end
            return albums
        end
        music_file = File.new("music_file.txt", "r")
        albums = read_albums(music_file)
        return albums
       end

  
    def needs_cursor?; true; end

  

    def draw_albums(albums)
        @bmp = Gosu::Image.new(albums[@album_global-1].artwork)
        @bmp.draw(0, 0 , z = ZOrder::PLAYER)
    end

    def draw_background()
        draw_quad(0,0, TOP_COLOR, 0, 600, TOP_COLOR, 800, 0, BOTTOM_COLOR, 800, 600, BOTTOM_COLOR, z = ZOrder::BACKGROUND)
    end

    def draw
        albums = load_album()
        i = 0
        x = 550
        y = 0
        draw_albums(albums)
        draw_background()

        if (!@song)
            @font.draw("#{albums[@album_global].title}", x , y+=100, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
        else
        @font.draw("Track List", x , y, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
            while i < albums[@album_global-1].tracks.length
                @font.draw("#{albums[@album_global-1].tracks[i].name}", x , y+=50, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
                if (albums[@album_global-1].tracks[i].track_iD == @track_global)
                    @font.draw("Now Playing: #{albums[@album_global-1].tracks[i].name}", 0 , 560, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
                end
                i+=1
            end
        end
        
    end

    def playTrack()
        albums = load_album()
        @song = Gosu::Song.new(albums[@album_global-1].tracks[@track_global-1].location)
        @song.play(false)
    end

    def area_clicked(mouse_x, mouse_y)
        if ((mouse_x >0 && mouse_x < 500)&& (mouse_y > 0 && mouse_y < 500 ))
            @track_global = 1
            playTrack()
        end  
    end

    def update()
        albums = load_album()
        if (@song)
            if (!@song.playing?)
                if @track_global < albums[@album_global-1].tracks.length
                    @song = Gosu::Song.new(albums[@album_global-1].tracks[@track_global].location)
                    @song.play(false)
                    @track_global+=1
                else
                    @song.stop
                end
            end        
        end
    end

    def button_down(id)
        case id
            when Gosu::MsLeft
                # What should happen here?
                @locs = [mouse_x, mouse_y]
                area_clicked(mouse_x, mouse_y)
            end
        end
    end
MusicPlayerMain.new.show if __FILE__ == $0