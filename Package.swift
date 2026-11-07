// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ProfileDock",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "profiledock", targets: ["profiledock"]),
        .executable(name: "ProfileLauncher", targets: ["ProfileLauncher"]),
        .executable(name: "ProfileDockMenu", targets: ["ProfileDockMenu"]),
        .library(name: "ProfileDockCore", targets: ["ProfileDockCore"]),
    ],
    targets: [
        .target(name: "ProfileDockCore"),
        .executableTarget(name: "ProfileLauncher"),
        .executableTarget(name: "profiledock", dependencies: ["ProfileDockCore"]),
        .executableTarget(name: "ProfileDockMenu", dependencies: ["ProfileDockCore"]),
        .testTarget(name: "ProfileDockCoreTests", dependencies: ["ProfileDockCore"]),
    ]
)
