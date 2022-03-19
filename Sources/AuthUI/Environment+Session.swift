import GoTrue
import SwiftUI

private enum SessionEnvironmentKey: EnvironmentKey {
  static var defaultValue: Session?
}

extension EnvironmentValues {
  public var session: Session? {
    get { self[SessionEnvironmentKey.self] }
    set { self[SessionEnvironmentKey.self] = newValue }
  }
}
