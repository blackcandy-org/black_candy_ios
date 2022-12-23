import SwiftUI
import ComposableArchitecture

struct MiniPlayerView: View {
  let store: StoreOf<PlayerReducer>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack(spacing: 0) {
        HStack(spacing: CustomStyle.spacing(.medium)) {
          AsyncImage(url: viewStore.currentSong?.albumImageUrl.small) { image in
            image.resizable()
          } placeholder: {
            Color.secondary
          }
          .cornerRadius(CustomStyle.cornerRadius(.small))
          .frame(width: CustomStyle.miniPlayerImageSize, height: CustomStyle.miniPlayerImageSize)

          Text(viewStore.currentSong?.name ?? NSLocalizedString("label.notPlaying", comment: ""))
        }

        Spacer()

        HStack(spacing: CustomStyle.spacing(.medium)) {
          Button(
            action: {
              if viewStore.isPlaying {
                viewStore.send(.pause)
              } else {
                viewStore.send(.play)
              }
            },
            label: {
              if viewStore.isPlaying {
                Image(systemName: "pause.fill")
                  .tint(.primary)
              } else {
                Image(systemName: "play.fill")
                  .tint(.primary)
              }
            }
          )
          .disabled(!viewStore.hasCurrentSong)

          Button(
            action: {
              viewStore.send(.next)
            },
            label: {
              Image(systemName: "forward.fill")
                .tint(.primary)
            }
          )
          .disabled(!viewStore.hasCurrentSong)
        }
      }
      .padding(.horizontal)
      .padding(.vertical, CustomStyle.spacing(.narrow))
    }
  }
}
