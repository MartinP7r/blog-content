// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "4.2.0"),
        .package(url: "https://github.com/martinP7r/swift-argument-parser", branch: "testhelper_product"),
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: [
                "Files",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "MyAppTests",
            dependencies: [
                "MyApp",
                .product(name: "ArgumentParserTestHelpers", package: "swift-argument-parser")
            ]),
    ]
)
