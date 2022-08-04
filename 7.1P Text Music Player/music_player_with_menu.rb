require './input_functions'
require './allclass'

def main_menu
    albums = []
    finished = false
    begin
        option = read_integer_in_range("MAIN MENU:\n1. Read in Albums\n2. Display Albums\n3. Select an Album to play\n4. Update an existing Album\n5. Exit the application\nOption:",1,5)
        case option
        when 1
            albums = read_in_albums()
        when 2
            display_albums(albums)
        when 3
            select_album_to_play(albums)
        when 4
            albums = update_existing_album(albums)
        when 5
            finished = true
        else
            puts 'Invalid option, please select again!'
        end
    end until finished
end 

def read_albums(file_name)
    music_file = File.new(file_name, "r")
    count = music_file.gets().to_i
    i = 0
    albums = Array.new()
    while i < count
        album = read_album(music_file)
        albums << album
        i += 1
    end
    read_string("#{albums.length} albums loaded.\nPress enter to continue")
    music_file.close
    return albums
end

##########
def read_in_albums()
    valid_file = false
    while (!valid_file) 
        accepted_formats = [".txt"]
        file_name = read_string('File name: ')
        if accepted_formats.include? File.extname(file_name)
            valid_file = File.exists?(file_name)
            if !(valid_file)
                puts "File not exist! Please enter again."        
            end
        else
            puts "This file is not supported\n"
            read_string("Press enter to continue")
        end
    end
    albums = read_albums(file_name)
    return albums
end
##########
def update_title(album)
    new_album_title = read_string("New Title:")
    album.title = new_album_title
end
##########
def update_genre(album)
    new_album_genre = read_integer_in_range("Please pick your new Genre\n1.Pop\n2.Classic\n3.Jazz\n4.Rock\nSelect the Gerne:",1,4)
    album.genre = new_album_genre
end
##########
def update_location(album,trackID)
    location_update = read_string("New Location:")
    album.tracks[trackID-1].location = location_update.chomp.to_s
end

def update_name(album,trackID)
    name_update = read_string("New Name:")
    album.tracks[trackID-1].name = name_update.chomp.to_s
    question = read_integer_in_range("Do you wish to update its location?\n1.Yes\n2.No",1,2)
    case question
    when 1
        update_location(album,trackID)
    when 2
        return
    end
end
##########
def update_existing_album(albums)
    if albums.length == 0
        read_string("You need to load some albums!!. Press enter to continue")
    else
        albums_count = albums.length
        print_albums(albums)
        albumID = read_integer_in_range("Album ID: ", 1, albums_count)
        album = albums[albumID-1]
        tracks_count = album.tracks.length
        option = read_integer_in_range("1.Update Title\n2.Update Genre\n3.Update Track Name",1,3)
        case option
        when 1  
            album.title = update_title(album)
        when 2
            album.genre = update_genre(album)
        when 3
            print_tracks(album.tracks)
            trackID = read_integer_in_range("Please select your track: ", 1, tracks_count)
            album.tracks[trackID-1].name = update_name(album,trackID)
        end
        return albums
        return albums.tracks
    end
end
##########
def read_track(music_file)
    name = music_file.gets()
    location = music_file.gets()
    track = Track.new(name,location)
end
##########
def read_tracks(music_file,track_count)
    tracks = Array.new()
    i = 0
    while i < track_count
        track = read_track(music_file)
        tracks << track
        i+=1
    end
    return tracks
end
##########
def read_album(music_file)
    title = music_file.gets
    artist = music_file.gets
    genre = music_file.gets
    track_count = music_file.gets.to_i
    if track_count < 15
        tracks = read_tracks(music_file,track_count)
        album = Album.new(artist,title,genre,tracks)
        return album
    else
        puts 'Select file contains less than 15 tracks'
    end
end
##########
def print_track(track)
    puts track.name
    puts "File path: #{track.location}"
end
##########
def print_album(album,id)
    puts "\n"
    puts "ALBUM ID " + id.to_s
    puts "Genre: " + $genre_names[album.genre.to_i].to_s
    puts album.title.to_s + " by " + album.artist.to_s 
    puts "\n"
end
##########
def print_tracks(tracks)
    i = 0
    puts "Track List"
    while i < tracks.length
        print (i+1).to_s + "."
        print_track(tracks[i])
        i+=1
    end
end
##########
def print_albums(albums)
    i = 0
    puts "Albums List"
    while i < albums.length
        print_album(albums[i],i+1)
        i+=1
    end
end
##########
def print_albums_genre(albums,number)
    i = 0
    while i < albums.length
        if albums[i].genre.to_i == number
            print_album(albums[i],i+1)            
        end
        i+=1    
    end
    if i == albums.length
        enter = read_string("Press Enter to Continue")
        if enter == "\n"
            return
        end

    end
end
##########
def display_albums(albums)
    if albums.length == 0
        read_string("You need to load some albums!!. Press enter to continue")
    else
        option = read_integer_in_range("1.Display All\n2.Display Genre\nOption Number: ",1,2)
        case option
        when 1
            print_albums(albums)
        when 2
            option = read_integer_in_range("1.Pop\n2.Classic\n3.Jazz\n4.Rock\nSelect the Gerne:",1,4)
            print_albums_genre(albums,option)
        end
    end
end
##########
def select_album_to_play(albums)
    if albums.length == 0
        read_string("You need to load some albums!!. Press enter to continue")
    else
        option = read_integer_in_range("1.Play by ID\n2.Search\nOption Number: ",1,2)
        case option
        when 1
            print_albums(albums)
            play_by_id(albums)
        when 2
            search = read_string("Search: ")
            play_search(albums,search)
        end
    end
end

def search_tracks(tracks, search)
    found_index = -1
    x = 0 #index for tracks
    tracks_count = tracks.length
    while x < tracks_count
        if tracks[x].name.chomp == search.chomp
            found_index = x
        else
            x+=1
        end       
    end
    return found_index
end

##########
# This will search through all tracks in all albums to find a track that
# matches the search string
def play_search(albums, search_string)
    albums_count = albums.length
    i = 0 #index for albums
    found = false
    while (i < albums_count) && !found
        album = albums[i]
        x = search_tracks(albums[i].tracks, search_string)
        if (x > -1)
            puts "Track Found"
            puts "#{album.tracks[x].name.chomp.to_s} in Album:#{album.title} by #{album.artist}\n"
            found = true
        else
            i += 1
        end    
    end
    if (!found)
        read_string("Sorry, the track does not exist in any album")
    end
end
##########
def play_by_id(albums)
    albums_count = albums.length
    albumID = read_integer_in_range("Album ID: ", 1, albums_count)
    album = albums[albumID - 1]
    tracks_count = album.tracks.length
    if tracks_count > 0
        print_tracks(album.tracks)
        trackID = read_integer_in_range("Choose a Track to play: ", 1, tracks_count)
        puts "\nPlaying:"
        print ("ALBUM: " + album.title)
        puts albums[albumID - 1].tracks[trackID - 1].name
        puts "Loading file at the location: " + albums[albumID - 1].tracks[trackID - 1].location
        read_string("Press Enter to Continue")
    else   
        puts "Tracks Not Found"
    end
end

main_menu
