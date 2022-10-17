import BenchmarkSupport
import InstrumentationBaggage
import Logging

@main extension BenchmarkRunner {}

@_dynamicReplacement(for: registerBenchmarks)
func benchmarks() {
    Benchmark("Logging without metadata provider",
              throughputScalingFactor: .mega,
              desiredDuration: .seconds(3)
    ) { benchmark in
        var logger = Logger(label: "benchmark", factory: SwiftLogNoOpLogHandler.init)
        logger.logLevel = .trace

        benchmark.startMeasurement()
        for _ in benchmark.throughputIterations {
            logger.trace("Example log message", metadata: ["ad-hoc": "42"])
        }
    }

    Benchmark(
        "Logging with metadata provider and task-local baggage",
        throughputScalingFactor: .mega,
        desiredDuration: .seconds(3),
        thresholds: [
            .wallClock: .init(relative: [.p99: 50])
        ]
    ) { benchmark in
        var logger = Logger(
            label: "benchmark",
            factory: SwiftLogNoOpLogHandler.init,
            metadataProvider: .init { baggage in return nil }
        )
        logger.logLevel = .trace

        let baggage = Baggage.topLevel
        Baggage.$current.withValue(baggage) {
            benchmark.startMeasurement()
            for _ in benchmark.throughputIterations {
                logger.trace("Example log message", metadata: ["ad-hoc": "42"])
            }
        }
    }
}
