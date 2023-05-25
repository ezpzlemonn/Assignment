import Foundation

let songs = [
    Song(title: "Sleep Music",
         url: Bundle.main.url(forResource: "sleepMusic", withExtension: "mp3")!,
         artworkURL: Bundle.main.url(forResource: "music", withExtension: "jpeg")!),
    Song(title: "Nature Noise",
         url: Bundle.main.url(forResource: "naturenoise", withExtension: "mp3")!,
         artworkURL: Bundle.main.url(forResource: "nature", withExtension: "jpeg")!),
    Song(title: "Ocean Noise",
         url: Bundle.main.url(forResource: "oceannoise", withExtension: "mp3")!,
         artworkURL: Bundle.main.url(forResource: "ocean", withExtension: "jpeg")!),
    Song(title: "Rain Noise",
         url: Bundle.main.url(forResource: "rainnoise", withExtension: "mp3")!,
         artworkURL: Bundle.main.url(forResource: "rain", withExtension: "jpeg")!),
    Song(title: "White Noise",
         url: Bundle.main.url(forResource: "whitenoise", withExtension: "mp3")!,
         artworkURL: Bundle.main.url(forResource: "whitenoise", withExtension: "jpeg")!),
]

let tabs = [
    Tab(title: "Sleep", songs: [songs[0]]),
    Tab(title: "Inner Peace", songs: [songs[1]]),
    Tab(title: "Stress", songs: [songs[2]]),
    Tab(title: "Anxiety", songs: [songs[3], songs[4]]),
]
