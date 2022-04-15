// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "SupabaseUI",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
  ],
  products: [
    .library(
      name: "SupabaseUI",
      targets: ["SupabaseUI", "AuthUI"]
    ),
    .library(name: "AuthUI", targets: ["AuthUI"]),
  ],
  dependencies: [
    .package(
      name: "Supabase",
      url: "https://github.com/supabase-community/supabase-swift",
      branch: "concurrency"
    ),
  ],
  targets: [
    .target(
      name: "SupabaseUI",
      dependencies: ["Supabase"]),
    .target(
      name: "AuthUI",
      dependencies: [
        "Supabase",
        "SupabaseUI",
      ]
    ),
  ]
)
