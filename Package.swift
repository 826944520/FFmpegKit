// swift-tools-version:5.9
import PackageDescription

// iOS-only: macOS/tvOS/visionOS/macCatalyst were dropped (see plan). The FFmpegKit
// target is a pure linker aggregator (Sources/FFmpegKit/FFmpegKit.c is empty), so the
// binary-target dependency list below is the authoritative set of libraries linked into
// the final FFmpegKit framework. The GPU stack (MoltenVK/libshaderc/libplacebo/libmpv)
// and transport/feature libs (libsrt/libsmbclient/libzvbi/libfontconfig/libbluray/lcms2)
// were removed because KSPlayer does not use them — keeping them would mean linking
// binaries built against FFmpeg 6.1 alongside the rebuilt 8.x Libav* (libmpv wraps the
// FFmpeg API and would conflict), so they are dropped rather than rebuilt.
let package = Package(
    name: "FFmpegKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "FFmpegKit",
//            type: .static,
            targets: ["FFmpegKit"]
        ),
        .library(name: "Libavcodec", targets: ["Libavcodec"]),
        .library(name: "Libavfilter", targets: ["Libavfilter"]),
        .library(name: "Libavformat", targets: ["Libavformat"]),
        .library(name: "Libavutil", targets: ["Libavutil"]),
        .library(name: "Libswresample", targets: ["Libswresample"]),
        .library(name: "Libswscale", targets: ["Libswscale"]),
        // Crypto/TLS libraries exposed for consumers that link Libav*
        // individually without the full FFmpegKit target
        .library(name: "gmp", targets: ["gmp"]),
        .library(name: "nettle", targets: ["nettle"]),
        .library(name: "hogweed", targets: ["hogweed"]),
        .library(name: "gnutls", targets: ["gnutls"]),
        .library(name: "libass", targets: ["libfreetype", "libfribidi", "libharfbuzz", "libass"]),
        .plugin(name: "BuildFFmpeg", targets: ["BuildFFmpeg"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .target(
            name: "FFmpegKit",
            dependencies: [
                "libdav1d",
                "libfreetype", "libfribidi", "libharfbuzz", "libass",
                "gmp", "nettle", "hogweed", "gnutls",
                "Libavcodec", "Libavdevice", "Libavfilter", "Libavformat", "Libavutil", "Libswresample", "Libswscale",
            ],
            linkerSettings: [
                .linkedFramework("AudioToolbox"),
                .linkedFramework("AVFAudio"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreAudio"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("Foundation"),
                .linkedFramework("Metal"),
                .linkedFramework("IOKit"),
                .linkedFramework("IOSurface"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("Security"),
                .linkedFramework("UIKit"),
                .linkedFramework("VideoToolbox"),
                .linkedLibrary("bz2"),
                .linkedLibrary("c++"),
                .linkedLibrary("iconv"),
                .linkedLibrary("resolv"),
                .linkedLibrary("xml2"),
                .linkedLibrary("z"),
            ]
        ),
//        .target(
//            name: "libavutil",
//            cSettings: [.headerSearchPath("../")]
//        ),
//        .executableTarget(
//            name: "BuildFFmpegPlugin",
//            path: "Plugins/BuildFFmpeg"
//        ),
        .plugin(
            name: "BuildFFmpeg", capability: .command(
                intent: .custom(
                    verb: "BuildFFmpeg",
                    description: "You can customize FFmpeg and then compile FFmpeg"
                ),
                permissions: [
                    //                    .writeToPackageDirectory(reason: "This command compile FFmpeg and generate xcframework. compile FFmpeg need brew install nasm sdl2 cmake. So you need add --allow-writing-to-directory /usr/local/ --allow-writing-to-directory ~/Library/ or add --disable-sandbox"),
//                    .allowNetworkConnections(scope: .all(), reason: "The plugin must connect to a remote server to brew install nasm sdl2 cmake"),
                ]
            )
        ),
        .binaryTarget(
            name: "libdav1d",
            path: "Sources/libdav1d.xcframework"
        ),
        .binaryTarget(
            name: "Libavcodec",
            path: "Sources/Libavcodec.xcframework"
        ),
        .binaryTarget(
            name: "Libavdevice",
            path: "Sources/Libavdevice.xcframework"
        ),
        .binaryTarget(
            name: "Libavfilter",
            path: "Sources/Libavfilter.xcframework"
        ),
        .binaryTarget(
            name: "Libavformat",
            path: "Sources/Libavformat.xcframework"
        ),
        .binaryTarget(
            name: "Libavutil",
            path: "Sources/Libavutil.xcframework"
        ),
        .binaryTarget(
            name: "Libswresample",
            path: "Sources/Libswresample.xcframework"
        ),
        .binaryTarget(
            name: "Libswscale",
            path: "Sources/Libswscale.xcframework"
        ),
        .binaryTarget(
            name: "libfreetype",
            path: "Sources/libfreetype.xcframework"
        ),
        .binaryTarget(
            name: "libfribidi",
            path: "Sources/libfribidi.xcframework"
        ),
        .binaryTarget(
            name: "libharfbuzz",
            path: "Sources/libharfbuzz.xcframework"
        ),
        .binaryTarget(
            name: "libass",
            path: "Sources/libass.xcframework"
        ),
        .binaryTarget(
            name: "gmp",
            path: "Sources/gmp.xcframework"
        ),
        .binaryTarget(
            name: "nettle",
            path: "Sources/nettle.xcframework"
        ),
        .binaryTarget(
            name: "hogweed",
            path: "Sources/hogweed.xcframework"
        ),
        .binaryTarget(
            name: "gnutls",
            path: "Sources/gnutls.xcframework"
        ),
//        .binaryTarget(
//            name: "libssl",
//            path: "Sources/libssl.xcframework"
//        ),
//        .binaryTarget(
//            name: "libcrypto",
//            path: "Sources/libcrypto.xcframework"
//        ),
    ]
)
