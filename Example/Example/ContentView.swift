//
//  ContentView.swift
//  Example
//
//  Created by Guilherme Souza on 13/02/22.
//

import AuthUI
import SwiftUI

struct ContentView: View {
  var body: some View {
    AuthView {
      ScrollView(.vertical) {
        Text("Hello")
      }
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
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let data = try! JSONEncoder().encode(self)
    return String(data: data, encoding: .utf8)!
  }
}
