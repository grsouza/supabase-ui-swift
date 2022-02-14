// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "SupabaseUI",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "SupabaseUI",
      targets: ["SupabaseUI", "AuthUI"]
    ),
    .library(name: "AuthUI", targets: ["AuthUI"]),
  ],
  dependencies: [
    .package(
      name: "AsyncCompatibilityKit",
      url: "https://github.com/JohnSundell/AsyncCompatibilityKit",
      from: "0.1.2"
    ),
    .package(
      name: "Supabase",
      url: "https://github.com/grsouza/supabase-swift",
      .branch("master")
    ),
  ],
  targets: [
    .target(name: "SupabaseUI", dependencies: ["Supabase"]),
    .target(
      name: "AuthUI",
      dependencies: [
        "AsyncCompatibilityKit",
        "Supabase",
        "SupabaseUI",
      ]
    ),
  ]
)
