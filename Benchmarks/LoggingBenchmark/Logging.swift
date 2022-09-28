import BenchmarkSupport
import InstrumentationBaggage
import Logging

@main extension BenchmarkRunner {}

@_dynamicReplacement(for: registerBenchmarks)
func benchmarks() {
    Benchmark("Logging without metadata provider") { benchmark in
        print(benchmark.thresholds ?? "No threshholds")
        var logger = Logger(label: "benchmark", factory: SwiftLogNoOpLogHandler.init)
        logger.logLevel = .trace

        benchmark.startMeasurement()
        logger.trace("Example log message", metadata: ["ad-hoc": "42"])
    }

    Benchmark(
        "Logging with metadata provider and task-local baggage",
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
            logger.trace("Example log message", metadata: ["ad-hoc": "42"])
        }
    }
}
