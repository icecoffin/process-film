// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "process-film",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library( name: "ProcessFilm", targets: ["ProcessFilm"]),
        .executable(name: "process-film", targets: ["process-film"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "ProcessFilm",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .executableTarget(
            name: "process-film",
            dependencies: ["ProcessFilm"]
        ),
        .testTarget(
            name: "ProcessFilmTests",
            dependencies: ["ProcessFilm"]
        ),
    ]
)
