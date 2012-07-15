module Play
  # Queue is a queued listing of songs waiting to be played. It's a simple
  # playlist in iTunes, which Play manicures by maintaining [queue+1] songs and
  # pruning played songs (since histories are stashed in redis).
  class Queue

    # The name of the Playlist we'll stash in iTunes.
    #
    # Returns a String.
    def self.name
      'iTunes DJ'
    end

    # The Playlist object that the Queue resides in.
    #
    # Returns an Appscript::Reference to the Playlist.
    def self.playlist
      Play::Player.app.sources.first.playlists.select do |p|
        p.name == 'iTunes DJ'
      end.first
    end

    # Get the queue start offset for the iTunes DJ playlist.
    #
    # iTunes DJ keeps the current song in the playlist and
    # x number of songs that have played. This method returns
    # the current song index in the playlist. Using this we
    # can calculate how many songs iTunes is keeping as history.
    #
    # Example:
    #
    #   Calculate how many songs kept as history:
    #     playlist_offset - 1
    #
    #
    # Returns Integer offset to queued songs.
    def self.playlist_offset
      Play::Player.app.current_track.index
    end

    # Public: Adds a song to the Queue.
    #
    # song - A Song instance.
    #
    # Returns a Boolean of whether the song was added.
    def self.add_song(song)
      Play::Player.app.duplicate(song.record, :to => self.playlist)
    end

    # Public: Removes a song from the Queue.
    #
    # song - A Song instance.
    #
    # Returns a Boolean of whether the song was removed maybe.
    def self.remove_song(song)
      self.playlist.tracks.select do |t|
        t.persistent_id == song.id
      end.first.delete
    end

    # Clear the queue. Shit's pretty destructive.
    #
    # Returns who the fuck knows.
    def self.clear
      self.playlist.tracks.each { |record| record.delete }
    end

    # Ensure that we're currently playing on the Play playlist. Don't let anyone
    # else use iTunes, because fuck 'em.
    #
    # Returns nil.
    def self.ensure_playlist
      if Play::Player.app.current_playlist.name != name
        self.playlist.play
      end
    rescue Exception => e
      # just in case!
    end

    # The songs currently in the Queue.
    #
    # Returns an Array of Songs.
    def self.songs
      songs = playlist.tracks.map do |record|
        Song.find(record.persistent_id)
      end
      songs.slice(playlist_offset, songs.length - playlist_offset)
    rescue Exception => e
      # just in case!
      nil
    end

    # Is this song queued up to play?
    #
    # Returns a Boolean.
    def self.queued?(song)
      self.playlist.tracks.select do |t|
        t.persistent_id == song.id
      end.size > 0
    end

    # Returns the context of this Queue as JSON. This contains all of the songs
    # in the Queue.
    #
    # Returns an Array of Songs.
    def self.to_json
      hash = {
        :songs => songs
      }
      Yajl.dump hash
    end

  end
end
