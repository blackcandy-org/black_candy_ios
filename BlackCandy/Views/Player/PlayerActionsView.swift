import SwiftUI
import ComposableArchitecture

struct PlayerActionsView: View {
  let store: StoreOf<PlayerReducer>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }, content: { viewStore in
      HStack {
        Button(
          action: {
            viewStore.send(.nextMode)
          },
          label: {
            Image(systemName: viewStore.mode.symbol)
              .tint(viewStore.mode == .noRepeat ? .primary : .white)
          }
        )
        .padding(CustomStyle.spacing(.narrow))
        .background(viewStore.mode == .noRepeat ? .clear : .accentColor)
        .cornerRadius(CustomStyle.cornerRadius(.medium))

        Spacer()

        Button(
          action: {
            viewStore.send(.toggleFavorite)
          },
          label: {
            if viewStore.currentSong?.isFavorited ?? false {
              Image(systemName: "heart.fill")
                .tint(.red)
            } else {
              Image(systemName: "heart")
                .tint(.primary)
            }
          }
        )
        .padding(CustomStyle.spacing(.narrow))
        .disabled(!viewStore.hasCurrentSong)

        Spacer()

        Button(
          action: {
            viewStore.send(.togglePlaylistVisible)
          },
          label: {
            Image(systemName: "list.bullet")
              .tint(viewStore.isPlaylistVisible ? .white : .primary)
          }
        )
        .padding(CustomStyle.spacing(.narrow))
        .background(viewStore.isPlaylistVisible ? Color.accentColor : .clear)
        .cornerRadius(CustomStyle.cornerRadius(.medium))
      }
    })
  }
}

struct PlayerActionsView_Previews: PreviewProvider {
  static var previews: some View {
    PlayerActionsView(
      store: Store(initialState: PlayerReducer.State()) {}
    )
  }
}
