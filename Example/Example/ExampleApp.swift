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
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://ywlwyobfgvfsmkdvkxds.supabase.co")!,
  supabaseKey:
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNjQzMDU0ODQyLCJleHAiOjE5NTg2MzA4NDJ9.vnue-Ur8347d8W2sZj6fFqIOEHU-4E8yGEtlU-tCW-g"
)
