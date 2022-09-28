//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2020-2021 Apple Inc. and the Swift Distributed Tracing project
// authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import _LoggingBenchmarkTools
import Logging
import InstrumentationBaggage

private var logger: Logger!

public let LoggingBenchmarks: [BenchmarkInfo] = [
    BenchmarkInfo(
        name: "LoggingBenchmarks.000_bench_withoutMetadataProvider",
        runFunction: { _ in
            for _ in 0 ..< 1000 {
                logger.trace("Example", metadata: ["ad-hoc": "42"])
            }
        },
        tags: [],
        setUpFunction: {
            logger = Logger(label: "benchmark", factory: SwiftLogNoOpLogHandler.init)
            logger.logLevel = .trace
        },
        tearDownFunction: { logger = nil }
    ),
    BenchmarkInfo(
        name: "LoggingBenchmarks.001_bench_withMetadataProvider",
        runFunction: { _ in
            Baggage.$current.withValue(.topLevel) {
                for i in 0 ..< 1000 {
                    logger.trace("Example log from iteration \(i).", metadata: ["ad-hoc": "42"])
                }
            }
        },
        tags: [],
        setUpFunction: {
            logger = Logger(label: "benchmark", metadataProvider: .init { _ in
                return nil
            })
            logger.logLevel = .trace
        },
        tearDownFunction: { logger = nil }
    ),
    BenchmarkInfo(
        name: "LoggingBenchmarks.002_bench_withMetadataProviderExplicitBaggage",
        runFunction: { _ in
            for i in 0 ..< 1000 {
                logger.trace("Example log from iteration \(i).", metadata: ["ad-hoc": "42"], baggage: .topLevel)
            }
        },
        tags: [],
        setUpFunction: {
            logger = Logger(label: "benchmark", metadataProvider: .init { _ in
                return nil
            })
            logger.logLevel = .trace
        },
        tearDownFunction: { logger = nil }
    ),
]
