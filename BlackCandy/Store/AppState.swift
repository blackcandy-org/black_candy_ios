import Foundation
import ComposableArchitecture
import Turbo

struct AppState: Equatable {
  var alert: AlertState<AppAction>?
  var serverAddress: URL?
  var apiToken: String?
  var currentUser: User?

  var isLoggedIn: Bool {
    currentUser != nil
  }

  var isAdmin: Bool {
    currentUser?.isAdmin ?? false
  }

  var playerState = PlayerState()

  struct PlayerState: Equatable {
    var playlist = Playlist()
    var isPlaying = false
    var currentIndex = 0

    var currentSong: Song? {
      playlist.songs?[currentIndex]
    }
  }
}
