/*
Создать Stream чисел от 1 до бесконечности с интервалом в 1 секунду, применить map(), where(), take() (пример: первые 5 чётных чисел, умноженных на 2).
*/

Stream<int> infiniteNumbers() async* {
  int n = 1;

  while (true) {
    await Future.delayed(Duration(seconds: 1));
    yield n;
    n++;
  }
}

void main() async {
  final Stream<int> numbers = infiniteNumbers();

  await numbers
      .where((n) => n % 2 == 0)
      .take(5)
      .map((n) => n * 2)
      .forEach(print);
}
