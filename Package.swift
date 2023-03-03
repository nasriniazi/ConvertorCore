// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConvertorCore",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ConvertorCore",
            targets: ["ConvertorCore"]),
    ],
    dependencies: [.package(url: "https://github.com/nasriniazi/Network.git", branch: "main"),.package(url:"https://github.com/ReactiveX/RxSwift.git", .exact("6.5.0")),.package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", .upToNextMajor(from: "9.0.0"))],
    targets: [
        .target(
            name: "ConvertorCore",
            dependencies: [.product(name: "Network", package: "Network"),.product(name: "RxSwift", package: "RxSwift"),.product(name: "RxCocoa", package: "RxSwift")]),
        .testTarget(
            name: "ConvertorCoreTests",
            dependencies: [.target(name: "ConvertorCore"),.product(name: "OHHTTPStubs", package: "OHHTTPStubs")])
    ]
)
