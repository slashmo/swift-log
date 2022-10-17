// swift-tools-version:5.6
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Logging API open source project
//
// Copyright (c) 2018-2019 Apple Inc. and the Swift Logging API project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Logging API project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "swift-log",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "Logging", targets: ["Logging"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-distributed-tracing-baggage", from: "0.3.0"),
        .package(url: "https://github.com/ordo-one/package-benchmark", .upToNextMajor(from: "0.4.1")),
    ],
    targets: [
        .target(
            name: "Logging",
            dependencies: [
                .product(name: "InstrumentationBaggage", package: "swift-distributed-tracing-baggage"),
            ]
        ),
        .testTarget(
            name: "LoggingTests",
            dependencies: ["Logging"]
        ),
        .executableTarget(
            name: "LoggingBenchmark",
            dependencies: [
                .product(name: "BenchmarkSupport", package: "package-benchmark"),
                .product(name: "InstrumentationBaggage", package: "swift-distributed-tracing-baggage"),
                .target(name: "Logging"),
            ],
            path: "Benchmarks/LoggingBenchmark"
        ),

        // MARK: Performance / Benchmarks
        .executableTarget(
            name: "_LoggingBenchmarks",
            dependencies: [
                .product(name: "InstrumentationBaggage", package: "swift-distributed-tracing-baggage"),
                .target(name: "Logging"),
                .target(name: "_LoggingBenchmarkTools"),
            ]
        ),
        .target(
            name: "_LoggingBenchmarkTools",
            dependencies: [],
            exclude: ["README_SWIFT.md"]
        ),
    ]
)
