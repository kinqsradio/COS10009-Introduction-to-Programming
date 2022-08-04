require 'rubygems'
require 'gosu'
require './input_functions'

TOP_COLOR = Gosu::Color::WHITE
BOTTOM_COLOR = Gosu::Color::WHITE

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
        super 1200, 1100
        self.caption = "Tran Duc Anh Dang - Music Player"
        @locs = [60,60]
        @font = Gosu::Font.new(25)

        ##### 
        @album_global = nil
        @track_global = nil
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
                if count <= 15
                    track = read_track(music_file, i+1)
                    tracks << track
                    i+=1
                else
                    puts "Tracks exceed its limit"
                end
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
        @bmp = Gosu::Image.new(albums[0].artwork)
        @bmp.draw(0, 0, z = ZOrder::PLAYER)
        @bmp = Gosu::Image.new(albums[1].artwork)
        @bmp.draw(500, 0, z = ZOrder::PLAYER)
        @bmp = Gosu::Image.new(albums[2].artwork)
        @bmp.draw(0, 500, z = ZOrder::PLAYER)
        @bmp = Gosu::Image.new(albums[3].artwork)
        @bmp.draw(500, 500, z = ZOrder::PLAYER)
    end

    def draw_background()
        draw_quad(0,0, TOP_COLOR, 0, 1080, TOP_COLOR, 1920, 0, BOTTOM_COLOR, 1920, 1080, BOTTOM_COLOR, z = ZOrder::BACKGROUND)
    end

    def draw
        albums = load_album()
        i = 0
        x = 1000
        y = 515
        draw_albums(albums)
        draw_background()
        @font.draw("mouse_x: #{mouse_x}", 1000, 0, ZOrder::UI, 0.5, 0.5, Gosu::Color::BLACK)
        @font.draw("mouse_y: #{mouse_y}", 1000, 20, ZOrder::UI, 0.5, 0.5, Gosu::Color::BLACK )
        if (@song)
            @font.draw("Album: #{albums[@album_global-1].title}", 0, 1025, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
            @font.draw("Track List", 1050 , 505, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
            while i < albums[@album_global-1].tracks.length
                @font.draw("#{albums[@album_global-1].tracks[i].track_iD}. #{albums[@album_global-1].tracks[i].name}", x+20 , y+=25, ZOrder::UI, 0.8, 0.8, Gosu::Color::BLACK)
                if (albums[@album_global-1].tracks[i].track_iD == @track_global)         
                    @font.draw("Now Playing: #{albums[@album_global-1].artist.chomp} - #{albums[@album_global-1].tracks[@track_global-1].name}", 0, 1000, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
                end
                i+=1
            end
        end
        
    end

    def playTrack(a,t)
        albums = load_album()
        @album_global = a 
        @track_global = t
        @song = Gosu::Song.new(albums[@album_global-1].tracks[@track_global - 1].location)
        @song.play(false)
    end

    def area_clicked(mouse_x, mouse_y)
        albums = load_album()
        if ((mouse_x > 0 && mouse_x < 500)&& (mouse_y > 0 && mouse_y < 500 ))
            @album_global = 1
            @track_global = 1
            playTrack(@album_global,@track_global)
        end
        if ((mouse_x > 500 && mouse_x < 1000)&& (mouse_y > 0 && mouse_y < 500 ))
            @album_global = 2
            @track_global = 1
            playTrack(@album_global,@track_global)
        end
        if ((mouse_x > 0 && mouse_x < 500)&& (mouse_y > 500 && mouse_y < 1000 ))
            @album_global = 3
            @track_global = 1
            playTrack(@album_global,@track_global)
        end 
        if ((mouse_x > 500 && mouse_x < 1000)&& (mouse_y > 500 && mouse_y < 1000 ))
            @album_global = 4
            @track_global = 1
            playTrack(@album_global,@track_global)
        end 

        #i = 0
        #x1 = 1000
        #x2 = 1200
        y1 = 540
        y2 = 560
        if @album_global != nil
            if ((mouse_x > 1000 && mouse_x < 1200 )&& (mouse_y > y1 && mouse_y < y2 ))
                @track_global = 1
                if @track_global <= albums[@album_global-1].tracks.length
                    playTrack(@album_global,@track_global)
                end
            end
            i = 1
            x = 2
            while i < albums[@album_global-1].tracks.length
                if ((mouse_x > 1000 && mouse_x < 1200 )&& (mouse_y > y1+25*i && mouse_y < y2+25*i ))
                    #@track_global = 2
                    if @track_global <= albums[@album_global-1].tracks.length
                        playTrack(@album_global,x)
                    end
                end
                x +=1
                i +=1
            end            
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
                @locs = [mouse_x, mouse_y]
                area_clicked(mouse_x, mouse_y)
            end
        end
    end
MusicPlayerMain.new.show if __FILE__ == $0