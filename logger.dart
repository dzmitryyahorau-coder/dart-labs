/*
Создать Logger с фабричным конструктором (Singleton), методы log(), warning(), info(), error()
*/

enum LogLevel {
  info,
  warn,
  error
}

class Logger {
  
  static Logger? _instance;

  Logger._internalConstructor();

  factory create() {
    _instance ??= Logger._internalConstructor();

    return _instance!;
  }

  void log(Object message, {LogLevel level = LogLevel.info}) {
    final datetime = DateTime.now().toIso8601String();
    final prefix = level.name.toUpperCase();

    final strMessage = message.toString();

    print('[$datetime] [$prefix]: $strMessage');
  }

  void info(Object message) {
    log(message, level: LogLevel.info);
  }

  void warning(Object message) {
    log(message, level: LogLevel.warn);
  }

  void error(Object message) {
    log(message, level: LogLevel.error);
  }

}