// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FeatureCharacters",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "FeatureCharacters", targets: ["FeatureCharacters"]),
    ],
    dependencies: [
        .package(path: "../../Networking"),
        .package(path: "../../DesignSystem"),
    ],
    targets: [
        .target(
            name: "FeatureCharacters",
            dependencies: ["Networking", "DesignSystem"]
        ),
        .testTarget(
            name: "FeatureCharactersTests",
            dependencies: ["FeatureCharacters"]
        ),
    ]
)
