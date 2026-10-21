/*
Реализовать debounce-обёртку для асинхронных функций
*/

import 'dart:async';

// void Function(T) debounce<T>(void Function(T) fn, {
//   Duration duration = const Duration(milliseconds: 500),
// }) {
//   Timer? timer;

//   return (T args) {

//     timer = Timer(duration, () {
//       timer?.cancel();
//       fn(args);
//     });
//   };
// }

typedef AsyncFn<R, T> = Future<R> Function(T);

AsyncFn<R, Arg> debounce<R, Arg>(
  AsyncFn<R, Arg> fn, {
  Duration duration = const Duration(microseconds: 500),
}) {
  Timer? timer;
  Completer<R>? completer;

  return (Arg arg) {
    timer?.cancel();

    if (completer == null || completer!.isCompleted) {
      completer = Completer<R>();
    }

    timer = Timer(duration, () async {
      try {
        final R result = await fn(arg);
        if (!completer!.isCompleted) {
          completer!.complete(result);
        }
      } catch (err, st) {
        if (!completer!.isCompleted) {
          completer!.completeError(err, st);
        }
      }
    });

    return completer!.future;
  };
}

void main() async {
  // Тесты генерил с ИИ
  print(
    '=== ТЕСТ 1: Быстрый ввод (должен выполниться только последний вызов) ===\n',
  );

  int executionCount = 0;

  // Имитация асинхронной функции (например, сетевого запроса)
  Future<String> searchApi(String query) async {
    executionCount++;
    print('  [API] Реальный вызов функции с query: "$query"');
    await Future.delayed(const Duration(milliseconds: 50));
    return 'Результат для "$query"';
  }

  final debouncedSearch = debounce<String, String>(
    searchApi,
    duration: const Duration(milliseconds: 200),
  );

  print('1. Вызываем с "F"');
  final f1 = debouncedSearch('F');

  await Future.delayed(const Duration(milliseconds: 50));
  print('2. Вызываем с "Flu" (прошло 50 мс)');
  final f2 = debouncedSearch('Flu');

  await Future.delayed(const Duration(milliseconds: 50));
  print('3. Вызываем с "Flutter" (прошло еще 50 мс)');
  final f3 = debouncedSearch('Flutter');

  // Ждем выполнения дебаунса
  print('Ожидаем завершения дебаунса...\n');
  final result3 = await f3;

  print('Результат f3: $result3');
  print('Количество реальных вызовов API: $executionCount');

  // Проверяем, что за `Future` получили первый и второй вызовы:
  final result1 = await f1;
  print('Результат f1 (переиспользовал completer): $result1');

  print('\n=== ТЕСТ 2: Одиночный вызов после паузы ===\n');

  await Future.delayed(
    const Duration(milliseconds: 400),
  ); // Даем таймеру полностью завершиться

  print('4. Вызываем с "Dart" после паузы');
  final result4 = await debouncedSearch('Dart');
  print('Результат f4: $result4');
  print('Всего вызовов API за всё время: $executionCount');

  print('\n=== ТЕСТ 3: Обработка ошибок в асинхронной функции ===\n');

  Future<String> failingApi(String query) async {
    print('  [API] Вызов функции с ошибкой для: "$query"');
    throw Exception('Сеть недоступна!');
  }

  final debouncedFailing = debounce<String, String>(
    failingApi,
    duration: const Duration(milliseconds: 100),
  );

  try {
    print('Отправляем запрос, который должен упасть...');
    await debouncedFailing('Test');
  } catch (e) {
    print('Поймана ошибка через try-catch: $e');
  }
}
