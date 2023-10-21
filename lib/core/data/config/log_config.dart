import 'package:f_logs/f_logs.dart';
import 'package:flutter/foundation.dart';
import 'package:demo/core/utils/logger.dart';

void setupLogging({bool isInTestFolder = false}) {
  Logger.enable(isInTestFolder: isInTestFolder);
  if (!isInTestFolder) {
    LogsConfig config = FLog.getDefaultConfigurations()
      ..formatType = FormatType.FORMAT_CUSTOM
      ..fieldOrderFormatCustom = [
        FieldName.LOG_LEVEL,
        FieldName.TIMESTAMP,
        FieldName.CLASSNAME,
        FieldName.METHOD_NAME,
        FieldName.TEXT,
        FieldName.EXCEPTION,
        FieldName.STACKTRACE,
      ]
      ..logLevelsEnabled = [
        LogLevel.INFO,
        LogLevel.ERROR,
        LogLevel.WARNING,
        if (kDebugMode) LogLevel.DEBUG
      ]
      ..customClosingDivider = " "
      ..customOpeningDivider = " "
      ..dataLogTypes = [
        DataLogType.DEVICE.toString(),
        DataLogType.NETWORK.toString(),
      ]
      ..timestampFormat = TimestampFormat.TIME_FORMAT_READABLE;

    if (kDebugMode) {
      config.activeLogLevel = LogLevel.DEBUG;
    } else {
      config.activeLogLevel = LogLevel.INFO;
    }

    FLog.applyConfigurations(config);
  }
}
