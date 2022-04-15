import Foundation
import Supabase
import SwiftUI

private enum SupabaseClientEnvironmentKey: EnvironmentKey {
  static var defaultValue = SupabaseClient(
    supabaseURL: URL(string: "https://supabase.com")!,
    supabaseKey: ""
  )
}

extension EnvironmentValues {
  public var supabase: SupabaseClient {
    get { self[SupabaseClientEnvironmentKey.self] }
    set { self[SupabaseClientEnvironmentKey.self] = newValue }
  }
}
