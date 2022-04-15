//
//  ExampleApp.swift
//  Example
//
//  Created by Guilherme Souza on 13/02/22.
//

import Supabase
import SupabaseUI
import SwiftUI

@main
struct ExampleApp: App {

  let supabase: SupabaseClient

  init() {
    supabase = SupabaseClient(
      supabaseURL: URL(string: "https://localhost:3000")!,
      supabaseKey: "key"
    )
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.supabase, supabase)
    }
  }
}
