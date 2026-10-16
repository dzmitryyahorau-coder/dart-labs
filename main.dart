/* 
Написать функции конвертации температуры Цельсий ↔ Фаренгейт.
*/

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
  var regExp = RegExp(r'^[a-zA-Z0-9_-.]+@[a-zA-Z0-9_-.]+\.{2,}$');

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

void main() {
  print(workWithStr('Dzmitry', 'Yahorau'));

  print(eratosthenesNums(5));

  print(fibIter(3));

  print(calculateAge(DateTime(2000, 6, 4)));
}