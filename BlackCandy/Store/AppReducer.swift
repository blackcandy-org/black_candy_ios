import Foundation
import SwiftUI
import ComposableArchitecture

struct AppReducer: Reducer {
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userDefaultsClient) var userDefaultsClient
  @Dependency(\.cookiesClient) var cookiesClient
  @Dependency(\.keychainClient) var keychainClient
  @Dependency(\.jsonDataClient) var jsonDataClient
  @Dependency(\.windowClient) var windowClient

  struct State: Equatable {
    @PresentationState var alert: AlertState<AlertAction>?

    var currentUser: User?
    var currentTheme = Theme.auto

    var isLoggedIn: Bool {
      currentUser != nil
    }

    var player: PlayerReducer.State {
      get {
        var state = _playerState
        state.alert = self.alert

        return state
      }

      set {
        self._playerState = newValue
        self.alert = newValue.alert
      }
    }

    var login: LoginReducer.State {
      get {
        var state = _loginState
        state.currentUser = self.currentUser

        return state
      }

      set {
        self._loginState = newValue
        self.currentUser = newValue.currentUser
      }
    }

    private var _loginState: LoginReducer.State = .init()
    private var _playerState: PlayerReducer.State = .init()
  }

  enum Action: Equatable {
    case alert(PresentationAction<AlertAction>)
    case dismissAlert
    case restoreStates
    case logout
    case logoutResponse(TaskResult<APIClient.NoContentResponse>)
    case updateTheme(State.Theme)
    case player(PlayerReducer.Action)
    case login(LoginReducer.Action)
  }

  enum AlertAction: Equatable {}

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .restoreStates:
        state.currentUser = jsonDataClient.currentUser()

        return .none

      case .logout:
        return .run { send in
          await send(
            .logoutResponse(
              TaskResult { try await apiClient.logout() }
            )
          )
        }

      case .logoutResponse:
        keychainClient.deleteAPIToken()
        jsonDataClient.deleteCurrentUser()
        windowClient.changeRootViewController(LoginViewController(store: AppStore.shared))

        state.currentUser = nil

        return .run { _ in
          await cookiesClient.cleanCookies()
        }

      case let .updateTheme(theme):
        state.currentTheme = theme
        return .none

      case .dismissAlert:
        return .send(.alert(.dismiss))

      case .player:
        return .none

      case .login:
        return .none

      case .alert:
        return .none
      }
    }
    .ifLet(\.$alert, action: /Action.alert)

    Scope(state: \.player, action: /Action.player) {
      PlayerReducer()
    }

    Scope(state: \.login, action: /Action.login) {
      LoginReducer()
    }
  }
}

extension AppReducer.State {
  enum Theme: String {
    case auto
    case light
    case dark

    var interfaceStyle: UIUserInterfaceStyle {
      switch self {
      case .dark:
        return .dark
      case .light:
        return .light
      case .auto:
        return .unspecified
      }
    }

    var colorScheme: ColorScheme? {
      switch self {
      case .dark:
        return .dark
      case .light:
        return .light
      case .auto:
        return nil
      }
    }
  }
}
