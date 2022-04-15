import GoTrue
import SupabaseUI
import SwiftUI

private enum UserEnvironmentKey: EnvironmentKey {
  static var defaultValue: User?
}

extension EnvironmentValues {
  public var user: User? {
    get { self[UserEnvironmentKey.self] }
    set { self[UserEnvironmentKey.self] = newValue }
  }
}

extension View {
  public func withUser(_ user: User?) -> some View {
    environment(\.user, user)
  }
}

public struct UserProviderView<RootView: View>: View {
  @Environment(\.supabase) var supabase

  let rootView: () -> RootView

  @State private var user: User?

  public init(@ViewBuilder rootView: @escaping () -> RootView) {
    self.rootView = rootView
  }

  public var body: some View {
    rootView()
      .withUser(user)
      .task {
        let session = supabase.auth.session
        user = session?.user

        for await _ in supabase.auth.authEventChange.values {
          user = supabase.auth.session?.user
        }
      }
  }
}
