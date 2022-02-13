import Supabase
import SwiftUI

private enum SupabaseClientEnvironmentKey: EnvironmentKey {
  static var defaultValue = SupabaseClient(host: "", supabaseKey: "")
}

extension EnvironmentValues {
  public var supabase: SupabaseClient {
    get { self[SupabaseClientEnvironmentKey.self] }
    set { self[SupabaseClientEnvironmentKey.self] = newValue }
  }
}

public struct AuthView: View {

  @Environment(\.supabase) var supabase

  public init() {}

  public var body: some View {
    Text("AuthUI")
  }
}

#if DEBUG
  struct AuthView_Preview: PreviewProvider {
    static var previews: some View {
      AuthView()
    }
  }
#endif
