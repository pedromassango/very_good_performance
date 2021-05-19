library very_good_performance;

import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:very_good_performance/src/models/models.dart';

extension VeryGoodPerformance on FlutterDriver {
  Future<void> capturePerformanceReport({
    required String reportName,
    required Future<dynamic> Function() action,
  }) async {
    final timeline = await traceAction(action);
    final summary = TimelineSummary.summarize(timeline);
    await summary.writeTimelineToFile(
      reportName,
      destinationDirectory: _configuration.performaceReport.directory,
      pretty: true,
    );
    final report = Report.fromJson(summary.summaryJson);
    print(report.toTable());
  }

  Configuration get _configuration {
    final stringYaml = File('very_good_performance.yaml').readAsStringSync();
    return Configuration.fromString(stringYaml);
  }
}