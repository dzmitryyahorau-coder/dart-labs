/* 
Написать функции конвертации температуры Цельсий ↔ Фаренгейт.
*/

import 'dart:io';
import 'dart:math';

import 'logger.dart';
import 'string-extension.dart';
import 'student.dart';

double convertCToF(double temp) => temp * 1.8 + 32;
double convertFToC(double temp) => (temp - 32) / 1.8;

/*
Реализовать работу со строками: конкатенация имени и фамилии, upper/lower case, подсчёт длины.
*/

String workWithStr(String firstName, String secondName) {
  final res = StringBuffer();

  res.write(firstName + ' ' + secondName + '\n');
  res.write(firstName.toLowerCase() + ' ' + secondName.toLowerCase() + '\n');
  res.write(firstName.toUpperCase() + ' ' + secondName.toUpperCase() + '\n');
  res.write("Length: ${firstName.length + secondName.length + 1}");

  return res.toString();
}

/*
Реализовать решето Эратосфена для поиска простых чисел до N.
*/

List<int> eratosthenesNums(int n) {
  final List<int> primes = [];

  for (int i = 2; i <= n; i++) {
    bool isPrime = true;

    for (final p in primes) {
      if (p * p > i) break;
      if (i % p == 0) {
        isPrime = false;
        break;
      }
    }

    if (isPrime) {
      primes.add(i);
    }
  }

  return primes;
}

/*
Реализовать рекурсивную и итеративную версии числа Фибоначчи, сравнить производительность.
*/

int fibRecursive(int n) { // O(2^N)
  if (n < 2) return n;

  return fibRecursive(n - 1) + fibRecursive(n - 2);
}

int fibIter(int n) { // O(n) speed / O(1) memory
  if (n < 2) return n;

  var a = 0;
  var b = 1;

  for (int i = 2; i <= n; i++) {
    final next = a + b;
    (a, b) = (b, next);
  }  

  return b;
}

/*
Написать функцию точного возраста (годы, месяцы, дни) по дате рождения
*/
(int years, int months, int days) calculateAge(DateTime birthday) {
  final now  = DateTime.now();

  var years = now.year - birthday.year;
  var months = now.month - birthday.month;
  var days = now.day - birthday.day;

  if (days < 0) {
    months--;

    final prevMonthDays = DateTime(now.year, now.month, 0);
    days += prevMonthDays.day;
  }

  if (months < 0) {
    years--;

    months += 12;
  }

  return (years, months, days);
}

/*
Написать валидатор email через RegExp с обработкой edge cases
*/
bool validateEmail(String email) {
  var regExp = RegExp(r'^[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\-\.]+\.[a-zA-Z]{2,}$');

  return regExp.hasMatch(email);
}

/*
Написать подсчёт частоты слов в тексте — топ-10.
*/
List<String> freqTop10(String text) {
  final freq = <String, int>{};

  final cleanedText = text.toLowerCase().replaceAll(RegExp(r'[^\w[а-яА-ЯёË\s]'), ''); // clean of punctuation marks
  final words = cleanedText.split(RegExp(r'\s+'));

  for (final word in words) {
    freq.update(word, (count) => count + 1, ifAbsent: () => 1);
  }

  final seq = freq.entries.toList();

  seq.sort((a, b) => b.value.compareTo(a.value));

  return seq.take(10).map((record) => record.key).toList();
}

/*
Написать валидатор номера банковской карты
*/

bool validateBankCardNumber(String num) {

  num = num.replaceAll(RegExp(r'[\s-]+'), '');
  if (!RegExp(r'^\d{13,19}$').hasMatch(num)) return false;

  final numsInt = num.split('').map((n) => int.parse(n)).toList();
  var sum = 0;

  var isSecond = false;

  for (int i = numsInt.length - 1; i >= 0; i--) {
    if (isSecond) {
      var doubled = numsInt[i] * 2;

      if (doubled > 9) {
        doubled -= 9;
      }

      sum += doubled;
    } else {
      sum += numsInt[i];
    }

    isSecond = !isSecond;
  }

  return sum % 10 == 0;
}

/*
Реализовать игру «Угадай число»
*/

bool Function(int) guessNumber(int start, int end) {
  if (start > end) throw new Exception('Invalid args: end number must be greater than start number.');

  final guessedNumber = Random().nextInt(end-start + 1) + start;
  bool isGuessed = false;

  print('Try yo guess my number from $start to $end');

  bool tryGuess(int n) {

    if (n > guessedNumber) {
      print('Guessed number is less than $n\n');
    } else if (n < guessedNumber) {
      print('Guessed number is greater than $n\n');
    } else {
      print('You won! Guessed number is $n!');
      isGuessed = true;
    }

    return isGuessed;
  }

  return tryGuess;
}

void main() {

  final logger = Logger.create();

  logger.log(workWithStr('Dzmitry', 'Yahorau'));

  logger.log(eratosthenesNums(5));

  logger.log(fibIter(3));

  logger.log(calculateAge(DateTime(2000, 6, 4)));

  final tryGuess = guessNumber(1, 100);

  bool isGuessed = true;

  while (!isGuessed) {
    stdout.write("Enter the number: ");

    final input = stdin.readLineSync();

    final userNumber = int.tryParse(input ?? '');

    if (userNumber == null) {
      logger.error('Number is wrong. Please, enter the valid integer number;');
      continue;
    }

    isGuessed = tryGuess(userNumber);
  }

  List<Student> students = [
    const Student('Alex', 4),
    const Student('Erick', 2),
    const Student('Dima', 3),
    const Student('Michael', 1)
  ];

  students.sort();

  logger.log("Sorted students: $students");

  logger.log('dima'.capitalize() + ' ' + 'дима'.capitalize());
  logger.log('dmitrii.egorow2014@yandex.ru'.isEmail());
  logger.log('Hello, world!'.reverse());
}