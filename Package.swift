// swift-tools-version: 6.0

// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription

let swiftSettings: [SwiftSetting] = [
  SwiftSetting.enableExperimentalFeature("AccessLevelOnImport"),
  SwiftSetting.enableExperimentalFeature("BitwiseCopyable"),
  SwiftSetting.enableExperimentalFeature("IsolatedAny"),
  SwiftSetting.enableExperimentalFeature("MoveOnlyPartialConsumption"),
  SwiftSetting.enableExperimentalFeature("NestedProtocols"),
  SwiftSetting.enableExperimentalFeature("NoncopyableGenerics"),
  SwiftSetting.enableExperimentalFeature("TransferringArgsAndResults"),
  SwiftSetting.enableExperimentalFeature("VariadicGenerics"),

  SwiftSetting.enableUpcomingFeature("FullTypedThrows"),
  SwiftSetting.enableUpcomingFeature("InternalImportsByDefault"),

  // SwiftSetting.unsafeFlags([
  //   "-Xfrontend",
  //   "-warn-long-function-bodies=100"
  // ]),
  // SwiftSetting.unsafeFlags([
  //   "-Xfrontend",
  //   "-warn-long-expression-type-checking=100"
  // ])
]

let package = Package(
  name: "RadiantKit",
  platforms: [
    .iOS(.v17),
    .macCatalyst(.v17),
    .macOS(.v14),
    .tvOS(.v17),
    .visionOS(.v1),
    .watchOS(.v10)
  ],
  products: [
    .library(
      name: "RadiantKit",
      targets: ["RadiantKit"]
    ),
    .library(
      name: "RadiantDocs",
      targets: ["RadiantDocs"]
    ),
    .library(
      name: "RadiantPaging",
      targets: ["RadiantPaging"]
    ),
    .library(
      name: "RadiantProgress",
      targets: ["RadiantProgress"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "RadiantKit",
      swiftSettings: swiftSettings
    ),
    .target(
      name: "RadiantDocs",
      dependencies: ["RadiantKit"],
      swiftSettings: swiftSettings
    ),
    .target(
      name: "RadiantPaging",
      dependencies: ["RadiantKit"],
      swiftSettings: swiftSettings
    ),
    .target(
      name: "RadiantProgress",
      dependencies: [
        .product(
          name: "Logging",
          package: "swift-log",
          condition: .when(platforms: [.linux])
        )
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "RadiantKitTests",
      dependencies: [
        "RadiantKit"
      ]
    )
  ]
)

// swiftlint:enable explicit_acl explicit_top_level_acl
