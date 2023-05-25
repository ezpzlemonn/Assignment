import Foundation
import AudioToolbox

struct Tab {
    var title: String
    var songs: [Song]
}

struct Song {
    var title: String
    var url: URL
    var artworkURL: URL
    var duration: TimeInterval = 0

    init(title: String, url: URL, artworkURL: URL) {
        self.title = title
        self.url = url
        self.artworkURL = artworkURL

        var file: AudioFileID!

        AudioFileOpenURL(url as CFURL, .readPermission, 0, &file)

        var outDataSize = UInt32()

        AudioFileGetPropertyInfo(file, kAudioFilePropertyEstimatedDuration, &outDataSize, nil)

        let durationRawPointer = UnsafeMutableRawPointer.allocate(byteCount: Int(outDataSize), alignment: Int(outDataSize))
        defer {
            durationRawPointer.deallocate()
        }

        AudioFileGetProperty(file, kAudioFilePropertyEstimatedDuration, &outDataSize, durationRawPointer)

        duration = durationRawPointer.load(as: Double.self)
    }
}
