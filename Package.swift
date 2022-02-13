// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "SupabaseUI",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "SupabaseUI",
      targets: ["AuthUI"]
    ),
    .library(name: "AuthUI", targets: ["AuthUI"]),
  ],
  dependencies: [
    .package(name: "Supabase", url: "https://github.com/grsouza/supabase-swift", .branch("master"))
  ],
  targets: [
    .target(
      name: "AuthUI",
      dependencies: ["Supabase"]
    )
  ]
)
