/*
Написать divideNumbers(int a, int b) → Future, обработать деление на ноль через try-catch и .catchError()
*/

Future<int> divideNumbers(int a, int b) {
  try {
    if (b == 0) {
      throw ArgumentError('Dividing by zero!');
    }

    final int res = a ~/ b;

    return Future.value(res);
  } catch (e) {
    return Future.error(e);
  }
}

void main() async {
  await divideNumbers(10, 0).then(print).catchError((e) {
    print('Catched error! ${e.toString()}');
  });

  await divideNumbers(10, 2).then(print).catchError((e) {
    print('Catched error! ${e.toString()}');
  });
}
