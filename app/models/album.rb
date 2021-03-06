module Play
  class Album

    # Name of the Album.
    attr_accessor :name

    # Name of the Artist.
    attr_accessor :artist

    # Initializes a new Album instance.
    #
    # name   - The String name of the album.
    # artist - The String name of the artist.
    #
    # Returns the new Album.
    def initialize(name,artist)
      @name   = name
      @artist = artist
    end

    # Pull all of the songs from a given Album name.
    #
    # Returns an Array of Songs.
    def self.songs_by_name(name)
      Player.library.shared_tracks.select { |t| t.album == name }.map do |record|
        Song.new(record.persistent_id)
      end
    end

    # The songs attached to this album.
    #
    # Returns an Array of Songs.
    def songs
      Player.library.shared_tracks.select do |t|
        t.album == name &&
          t.artist == artist
      end.map do |record|
        Song.new(record.persistent_id)
      end
    end

    # Zips up an album and stashes in it a temporary directory.
    #
    # Returns nothing.
    def zipped!
      return if File.exist?(zip_path)
      FileUtils.mkdir_p "/tmp/play-zips"
      system 'zip', '-0rjq', zip_path, path
    end

    # The name of the zipfile.
    #
    # Returns a String.
    def zip_name
      "#{artist} - #{name}.zip"
    end

    # The path to the album on-disk. We can figure this out by looking at a
    # song on this album, and then traversing the path up a directory. That's
    # probably good.
    #
    # Returns a String path on the filesystem.
    def path
      File.expand_path('../', songs.first.path)
    end

    # The path to the zipfile.
    #
    # Returns a String.
    def zip_path
      "/tmp/play-zips/#{zip_name}"
    end
  end
end
