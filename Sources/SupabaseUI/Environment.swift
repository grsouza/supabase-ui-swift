import Foundation
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
