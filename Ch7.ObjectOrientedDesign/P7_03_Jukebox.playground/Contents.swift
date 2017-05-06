//: Playground - noun: a place where people can play

import UIKit

//  Jukebox: Design a musical jukebox using object-oriented principles.

class Song {
    private var name: String
    var artist: Artist?
    
    init(name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
    
    func getArtist() -> Artist? {
        if let artist = artist {
            return artist
        } else {
            return nil
        }
    }
    
}

class Artist {
    
    private var name: String
    private var songs = [Song]()
    
    init(name: String) {
        self.name = name
    }
    
    func setSongToArtist(song: Song) {
        song.artist = self
        songs.append(song)
    }
    
    func setMultipleSongsToArtist(s: [Song]) {
        for song in s {
            song.artist = self
        }
        songs.append(contentsOf: s)
    }
    
    func getName() -> String {
        return name
    }
    
    func getSongs() -> [Song] {
        return songs
    }
}


class User {
    private var name: String
    private var iD: Int
    init(name: String, iD: Int) {
        self.name = name
        self.iD = iD
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
    
    func setID(iD: Int) {
        self.iD = iD
    }
    
    func getID() -> Int {
        return iD
    }
    
    func addUser(name: String, iD: Int) -> User {
        return User(name: name, iD: iD)
    }
    
}

func == (lhs: CD, rhs: CD) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
class CD: Hashable {
    private var songs = [Song]()
    private var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func addSongs(s: [Song]) {
        songs.append(contentsOf: s)
    }
    
    var hashValue: Int {
        get {
            return name.hashValue
        }
    }
    
    func getSongs() -> [Song] {
        return songs
    }
    
    func getName() -> String {
        return name
    }
    
}

class CDPlayer {
    
    private var cd: CD?
    
    func getCD() -> CD? {
        return cd
    }
    
    func setCD(cd: CD) {
        self.cd = cd
        print("cd: \(cd.getName()) is selected")
    }
    
    func playCDSongs() {
        if let cd = cd {
            let songs = cd.getSongs()
            for song in songs {
                print("Playing song: \(song)")
            }
        }
    }
    
}

class Playlist {
    private var currentSong: Song?
    private var queue = [Song]() // Suppose to implement a queue as a linkedlist here but I won't do it here because I'm lazy :)
    
    func getNextSongToPlay() -> Song? {
        if queue.isEmpty {
            print("No songs in the queue yet")
            return nil
        }
        currentSong = queue.removeFirst()
        print("Song Selected: \(currentSong!.getName())")
        return currentSong
    }
    
    func queueUpSong(s: [Song]) {
        queue.append(contentsOf: s)
    }
    
    func playCurrentSong() {
        if currentSong == nil {
            print("There's no current song in the playlist")
            return
        } else {
            print("Playing: \(currentSong!.getName())")
        }
    }
    
    func addSongToPlayList(song: Song) {
        if currentSong == nil {
            currentSong = song
        } else {
            queue.append(song)
        }
    }
    
    func addMultipleSongsToPlayList(songs: [Song]) {
        for song in songs {
            addSongToPlayList(song: song)
        }
    }
    
    func showQueue() {
        var queueOfSongs = [String]()
        print("Current queue containg songs are: ")
        for i in stride(from: queue.count - 1, through: 0, by: -1) {
            let song = queue[i]
            queueOfSongs.append("\(song.getName()), \(song.getArtist()?.getName() ?? "No Artist Available")")
        }
        print(queueOfSongs)
        print("")
    }
    
    func playAllSongs() {
        print("Will be playing all the following songs: ")
        while !queue.isEmpty {
            let song = queue.removeFirst()
            print("Playing song: \(song.getName()), artist: \(song.getArtist()?.getName() ?? "No Artist for this song")")
        }
        print("")
    }
}

class Display {
    private var cdPlayer: CDPlayer?
    private var songs = [Song]()
    private var jukebox: JukeBox?
    
    
    func displaySongs() {
        for song in songs {
            print("song: \(song.getName()), artist: \(song.getArtist()?.getName() ?? "No Artist Available for this song")")
        }
        print("")
    }
    
    func addSongs(s: [Song]) {
        songs.append(contentsOf: s)
    }
    
    func setCDPlayer(cdPlayer: CDPlayer) {
        self.cdPlayer = cdPlayer
    }
    
    func showSongsInCD() {
        if let songsInCD = cdPlayer?.getCD()?.getSongs() {
            print("\nsongs in \(cdPlayer!.getCD()!.getName()) are: ")
            for song in songsInCD {
                print("song: \(song.getName()), artist: \(song.getArtist()?.getName() ?? "No Artist Avaialble")")
            }
        } else {
            print("CD not selected")
        }
        print("")
    }
}

class JukeBox {

    private var cdPlayer: CDPlayer
    private var user: User
    private var cdCollection: Set<CD>
    private var display: Display
    private var playList: Playlist
    
    init(cdPlayer: CDPlayer, user: User, cdCollection: Set<CD>, display: Display, playList: Playlist) {
        self.cdPlayer = cdPlayer
        self.user = user
        self.cdCollection = cdCollection
        self.display = display
        for cd in cdCollection {
            display.addSongs(s: cd.getSongs())
        }
        self.playList = playList
    }
    
    func showAllCDs() {
        var rval = "All the CD's are: ["
        for cd in cdCollection {
            rval += "\(cd.getName()), "
        }
        print(rval + "]")
        print("")
    }
    
    func selectCD(cd: CD) {
        cdPlayer.setCD(cd: cd)
        display.setCDPlayer(cdPlayer: cdPlayer)
    }
    
    func addSongsToJukeBox(songs: [Song]) {
        display.addSongs(s: songs)
    }
    
    func addSongsToPlayList(songs: [Song]) {
        playList.addMultipleSongsToPlayList(songs: songs)
    }
    
    func displaySongs() {
        display.displaySongs()
    }
    
    func showPlayList() {
        playList.showQueue()
    }
    
    func showCDSongs() {
        display.showSongsInCD()
    }
    
    func playAllSongsInPlayList() {
        playList.playAllSongs()
    }
    
    func getUser() -> User {
        return user
    }
    
    
}

class PlayJukeBox {
    
    func beginPlay() {
        let song1 = Song(name: "s1")
        let song2 = Song(name: "s2")
        let song3 = Song(name: "s3")
        let artist = Artist(name: "Anh Doan")
        artist.setMultipleSongsToArtist(s: [song1, song2, song3])
        let playList = Playlist()
        let cdPlayer = CDPlayer()
        let user = User(name: "The Biggest Clown Name Anh", iD: 1)
        let cd1 = CD(name: "cd1")
        let song4 = Song(name: "s4")
        let song5 = Song(name: "s5")
        let artist2 = Artist(name: "Off Doan")
        artist2.setMultipleSongsToArtist(s: [song4, song5])
        let song6 = Song(name: "s6")
        let song7 = Song(name: "s7")
        cd1.addSongs(s: [song4])
        let cd2 = CD(name: "cd2")
        cd2.addSongs(s: [song5])
        let cd3 = CD(name: "cd3")
        cd3.addSongs(s: [song6, song7])
        var set = Set<CD>()
        set.insert(cd1)
        set.insert(cd2)
        set.insert(cd3)
        let display = Display()
        let jukebox = JukeBox(cdPlayer: cdPlayer, user: user, cdCollection: set, display: display, playList: playList)
        let currentUser = jukebox.getUser()
        if currentUser.getName() == "The Biggest Clown Name Anh" {
            print(currentUser.getName())
            print("")
        } else {
            print("Some mysterious fool who's playing an imaginary jukebox.")
        }
        jukebox.addSongsToJukeBox(songs: [song1, song2, song3])
        jukebox.displaySongs()
        jukebox.showAllCDs()
        jukebox.selectCD(cd: cd1)
        jukebox.showCDSongs()
        jukebox.selectCD(cd: cd3)
        jukebox.showCDSongs()
        jukebox.addSongsToPlayList(songs: [song2, song3, song4, song5])
        jukebox.showPlayList()
        jukebox.playAllSongsInPlayList()
        jukebox.showPlayList()
    }
    
    
}

let music = PlayJukeBox()
music.beginPlay()































