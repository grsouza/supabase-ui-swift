import AsyncCompatibilityKit
import GoTrue
import Supabase
import SupabaseUI
import SwiftUI

public struct AuthView<AuthenticatedContent: View>: View {

  let magicLinkEnabled: Bool
  let authenticatedContent: () -> AuthenticatedContent

  @Environment(\.supabase) var supabase
  @State private var authEvent: AuthChangeEvent?

  public init(
    magicLinkEnabled: Bool = true,
    @ViewBuilder authenticatedContent: @escaping () -> AuthenticatedContent
  ) {
    self.magicLinkEnabled = magicLinkEnabled
    self.authenticatedContent = authenticatedContent
  }

  public var body: some View {
    Group {
      switch authEvent {
      case .none:
        if #available(iOS 14.0, *) {
          ProgressView()
        } else {
          Text("Loading...")
        }
      case .signedIn:
        authenticatedContent()
      case .signedOut, .userUpdated, .userDeleted, .passwordRecovery:
        SignInOrSignUpView(magicLinkEnabled: magicLinkEnabled)
      }
    }
    .task {
      for await authEventChange in supabase.auth.authEventChange.values {
        withAnimation {
          self.authEvent = authEventChange.event
        }
      }
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
  @State var error: Error?

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
      if let error = error {
        Text(error.localizedDescription).foregroundColor(.red).multilineTextAlignment(.center)
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
          .keyboardType(.emailAddress)
          .textContentType(.emailAddress)
          .autocapitalization(.none)
          .disableAutocorrection(true)
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
          .textContentType(.password)
          .autocapitalization(.none)
          .disableAutocorrection(true)
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
      isLoading = true
      defer { isLoading = false }

      do {
        switch mode {
        case .signIn:
          _ = try await supabase.auth.signIn(email: email, password: password)
        case .signUp:
          fatalError("Not supported")
        case .magicLink:
          fatalError("Not supported")
        //            try await supabase.auth.signIn(email: email)
        case .forgotPassword:
          fatalError("Not supported")
        }
      } catch {
        withAnimation {
          self.error = error
        }
      }
    }
  }
}

#if DEBUG
  struct AuthView_Preview: PreviewProvider {
    static var previews: some View {
      AuthView { Text("Preview") }
    }
  }
#endif
