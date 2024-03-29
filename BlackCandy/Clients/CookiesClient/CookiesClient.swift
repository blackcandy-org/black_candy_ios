import Foundation
import Dependencies
import WebKit

struct CookiesClient {
  var updateCookies: ([HTTPCookie]) async -> Void
  var cleanCookies: () async -> Void
}

extension CookiesClient: TestDependencyKey {
  static let testValue = Self(
    updateCookies: { _  in },
    cleanCookies: { }
  )
}

extension DependencyValues {
  var cookiesClient: CookiesClient {
    get { self[CookiesClient.self] }
    set { self[CookiesClient.self] = newValue }
  }
}
