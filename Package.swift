// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "AirdropFinder",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "AirdropFinder", targets: ["AirdropFinder"])
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect.git", from: "0.1.4"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.9.0"),
        .package(url: "https://github.com/web3swift-team/web3swift.git", from: "2.7.0")
    ],
    targets: [
        .executableTarget(
            name: "AirdropFinder",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "web3swift", package: "web3swift")
            ],
            path: "Sources/AirdropFinder"
        )
    ]
) 