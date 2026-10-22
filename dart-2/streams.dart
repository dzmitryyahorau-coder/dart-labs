/*
Создать Stream чисел от 1 до бесконечности с интервалом в 1 секунду, применить map(), where(), take() (пример: первые 5 чётных чисел, умноженных на 2).
*/

import 'dart:async';

Stream<int> infiniteNumbers() async* {
  int n = 1;

  while (true) {
    await Future.delayed(Duration(seconds: 1));
    yield n;
    n++;
  }
}

/*
второй способ, класс NumberGenerator
*/

class NumberGenerator {
  var _count = 1;
  var _controller = StreamController<int>();

  NumberGenerator() {
    Timer.periodic(Duration(seconds: 1), (t) {
      _controller.sink.add(_count);
      _count++;
    });
  }

  Stream<int> get stream => _controller.stream;
}

void main() async {
  final Stream<int> numbers = infiniteNumbers();
  final Stream<int> numbers2 = NumberGenerator().stream;

  await numbers
      .where((n) => n % 2 == 0)
      .take(5)
      .map((n) => n * 2)
      .listen(print);

  await numbers2
      .where((n) => n % 2 == 0)
      .take(5)
      .map((n) => n * 2)
      .listen(print);
}
