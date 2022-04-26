//
//  ContentView.swift
//  Example
//
//  Created by Guilherme Souza on 13/02/22.
//

import AuthUI
import GoTrue
import SwiftUI

struct ContentView: View {
  var body: some View {
    UserProviderView(supabaseClient: supabase) {
      AuthView(supabaseClient: supabase, loadingContent: ProgressView.init) { session in
        NavigationView {
          UserView(user: session.user)
            .navigationTitle("Logged in")
            .toolbar {
              ToolbarItem(placement: .navigationBarLeading) {
                Button("Log out") {
                  Task {
                    try await supabase.auth.signOut()
                  }
                }
              }
            }
        }
      }
    }
  }
}

struct UserView: View {

  let user: User

  var body: some View {
    ScrollView {
      Text(user.jsonFormatted())
        .padding()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

extension Encodable {
  func jsonFormatted() -> String {
    let encoder = JSONEncoder.goTrue
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let data = try! encoder.encode(self)
    return String(data: data, encoding: .utf8)!
  }
}
