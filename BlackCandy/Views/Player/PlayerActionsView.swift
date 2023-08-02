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
              .tint(.primary)
          }
        )
        .padding(CustomStyle.spacing(.tiny))
        .disabled(viewStore.isPlaylistVisible)

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
        .padding(CustomStyle.spacing(.tiny))
        .disabled(viewStore.isPlaylistVisible || !viewStore.hasCurrentSong)

        Spacer()

        Button(
          action: {
            viewStore.send(.togglePlaylistVisible)
          },
          label: {
            Image(systemName: "list.bullet")
              .tint(.primary)
          }
        )
        .padding(CustomStyle.spacing(.tiny))
        .background(viewStore.isPlaylistVisible ? Color.init(.systemGray3) : Color.clear)
        .cornerRadius(CustomStyle.cornerRadius(.small))
      }
    })
    .padding(.horizontal, CustomStyle.spacing(.large))
  }
}

struct PlayerActionsView_Previews: PreviewProvider {
  static var previews: some View {
    PlayerActionsView(
      store: Store(initialState: PlayerReducer.State()) {}
    )
  }
}
