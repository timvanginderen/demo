import 'package:f_logs/f_logs.dart';

class Logger {
  const Logger();

  static bool _enabled = false;

  static bool _isInTestFolder = false;

  static void enable({bool isInTestFolder = false}) {
    _enabled = true;
    _isInTestFolder = isInTestFolder;
  }

  /// Logs DEBUG level [message]
  /// with optional exception and stacktrace
  void d(String message, {dynamic ex, StackTrace? stacktrace, String? tag}) {
    if (_enabled) {
      final CustomTrace programInfo = CustomTrace(StackTrace.current);
      if (_isInTestFolder) {
        // ignore: avoid_print
        print('D/$message');
      } else {
        FLog.debug(
          text: message,
          exception: _LoggerException(ex),
          stacktrace: stacktrace,
          methodName: tag ?? programInfo.callerFunctionName,
          className: '',
        );
      }
    }
  }

  /// Logs INFO level [message]
  /// with optional exception and stacktrace
  void i(String message, {dynamic ex, StackTrace? stacktrace, String? tag}) {
    if (_enabled) {
      final CustomTrace programInfo = CustomTrace(StackTrace.current);
      if (_isInTestFolder) {
        // ignore: avoid_print
        print('I/$message');
      } else {
        FLog.info(
          text: message,
          exception: _LoggerException(ex),
          stacktrace: stacktrace,
          methodName: tag ?? programInfo.callerFunctionName,
          className: '',
        );
      }
    }
  }

  /// Logs WARNING level [message]
  /// with optional exception and stacktrace
  void w(String message, {dynamic ex, StackTrace? stacktrace, String? tag}) {
    if (_enabled) {
      final CustomTrace programInfo = CustomTrace(StackTrace.current);
      if (_isInTestFolder) {
        // ignore: avoid_print
        print('W/$message');
      } else {
        FLog.warning(
          text: message,
          exception: _LoggerException(ex),
          stacktrace: stacktrace,
          methodName: tag ?? programInfo.callerFunctionName,
          className: '',
        );
      }
    }
  }

  /// Logs ERROR level [message]
  /// with optional exception and stacktrace
  void e(String message, {dynamic ex, StackTrace? stacktrace, String? tag}) {
    if (_enabled) {
      final CustomTrace programInfo = CustomTrace(StackTrace.current);
      if (_isInTestFolder) {
        // ignore: avoid_print
        print('E/$message');
      } else {
        FLog.error(
          text: message,
          exception: _LoggerException(ex),
          stacktrace: stacktrace,
          methodName: tag ?? programInfo.callerFunctionName,
          className: '',
        );
      }
    }
  }
}

const Logger logger = Logger();

class _LoggerException implements Exception {
  _LoggerException(this.error);

  final dynamic error;

  @override
  String toString() {
    if (error != null) {
      final Type runType = error.runtimeType;
      String appException = ' $runType \t';
      if (error is Error) {
        appException += Error.safeToString(error);
      } else {
        appException += error.toString();
      }

      return appException;
    } else {
      return '';
    }
  }
}

class CustomTrace {
  CustomTrace(this._trace) {
    _parseTrace();
  }

  final StackTrace _trace;

  String? callerFunctionName;

  String _getFunctionNameFromFrame(String frame) {
    final String currentTrace = frame;

    /* To get rid off the #number thing, get the index of the first whitespace */
    int indexOfWhiteSpace = currentTrace.indexOf(' ');

    /* Create a substring from the first whitespace index till the end of the string */
    String subStr = currentTrace.substring(indexOfWhiteSpace);

    /* Grab the function name using reg expr */
    // ignore: unnecessary_raw_strings
    final int indexOfFunction = subStr.indexOf(RegExp(r'[A-Za-z0-9]'));

    /* Create a new substring from the function name index till the end of string */
    subStr = subStr.substring(indexOfFunction);

    indexOfWhiteSpace = subStr.indexOf(' ');

    /* Create a new substring from start to the first index of a whitespace. This substring gives us the function name */
    return subStr.substring(0, indexOfWhiteSpace);
  }

  void _parseTrace() {
    /* The trace comes with multiple lines of strings, (each line is also known as a frame), so split the trace's string by lines to get all the frames */
    final List<String> frames = _trace.toString().split('\n');

    /* The second frame is the caller function */
    callerFunctionName = _getFunctionNameFromFrame(frames[1]);
  }
}
