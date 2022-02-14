import Supabase
import SupabaseUI
import SwiftUI

public struct AuthView: View {

  let magicLinkEnabled: Bool

  @Environment(\.supabase) var supabase

  public init(magicLinkEnabled: Bool = true) {
    self.magicLinkEnabled = magicLinkEnabled
  }

  @ViewBuilder
  public var body: some View {
    if let session = supabase.auth.session {
      ScrollView(.vertical) {
        Text(session.jsonFormatted())
      }
    } else {
      SignInOrSignUpView(magicLinkEnabled: magicLinkEnabled)
    }
  }
}

struct SignInOrSignUpView: View {
  @Environment(\.supabase) var supabase

  enum Mode {
    case signIn, signUp, magicLink, forgotPassword
  }

  let magicLinkEnabled: Bool

  @State var email = ""
  @State var password = ""

  @State var mode: Mode = .signIn

  @State var isLoading = false

  var body: some View {
    VStack(spacing: 20) {
      emailTextField

      if mode == .signIn || mode == .signUp {
        passwordTextField
      }

      VStack(spacing: 12) {
        if mode == .signIn {
          HStack {
            Spacer()
            Button("Forgot your password?") {
              withAnimation { mode = .forgotPassword }
            }
          }
        }

        Button(action: primaryActionTapped) {
          HStack(spacing: 8) {
            if isLoading {
              if #available(iOS 14.0, *) {
                ProgressView()
              } else {
                Text("Submitting...").bold()
              }
            }

            Text(primaryButtonText).bold()
          }
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
          )
        }
        .disabled(isLoading)

        if mode == .forgotPassword {
          HStack {
            Button("Go back to sign in") {
              withAnimation { mode = .signIn }
            }

            Spacer()
          }
        }

        if magicLinkEnabled, mode == .signIn {
          Button("Sign in with magic link") {
            withAnimation { mode = .magicLink }
          }
        }

        if mode == .signIn || mode == .signUp {
          Button(
            mode == .signIn
              ? "Don't have an account? Sign up"
              : "Do you have an account? Sign in"
          ) {
            withAnimation { mode = mode == .signIn ? .signUp : .signIn }
          }
        }

        if mode == .magicLink {
          Button("Sign in with password") {
            withAnimation { mode = .signIn }
          }
        }
      }
    }
    .padding(20)
  }

  var emailTextField: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Email address").font(.subheadline)
      HStack {
        Image(systemName: "envelope")
        TextField("", text: $email)
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 6, style: .continuous)
          .stroke()
      )
    }
  }

  var passwordTextField: some View {
    VStack(alignment: .leading) {
      Text("Password").font(.subheadline)
      HStack {
        Image(systemName: "key")
        SecureField("", text: $password)
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 6, style: .continuous)
          .stroke()
      )
    }
  }

  var primaryButtonText: String {
    switch mode {
    case .signIn: return "Sign in"
    case .signUp: return "Sign up"
    case .magicLink: return "Send magic link"
    case .forgotPassword: return "Send reset password instructions"
    }
  }

  private func primaryActionTapped() {
    Task {
      if mode == .signIn {
        isLoading = true
        defer { isLoading = false }
        _ = try await supabase.auth.signIn(email: email, password: password)
      } else {
        fatalError("Not supported.")
      }
    }
  }
}

extension Encodable {
  func jsonFormatted() -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let data = try! JSONEncoder().encode(self)
    return String(data: data, encoding: .utf8)!
  }
}

#if DEBUG
  struct AuthView_Preview: PreviewProvider {
    static var previews: some View {
      AuthView()
    }
  }
#endif
