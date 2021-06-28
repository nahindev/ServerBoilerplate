// swift-tools-version:5.4
import PackageDescription

let package = Package(name: "ServerBoilerplate")

package.platforms = [
    .macOS(.v11),
]

package.dependencies = [
    .package(url: "https://github.com/nahindev/GRPCServer", .exact("0.0.1")),
]

package.targets = [
    .target(name: "ServerBoilerplate", dependencies: [
        .product(name: "GRPCServer", package: "GRPCServer"),
    ]),
]

package.products = [
    .library(name: "ServerBoilerplate", targets: ["ServerBoilerplate"]),
]
