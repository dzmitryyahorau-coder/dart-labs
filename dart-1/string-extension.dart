
/*
Создать extension-методы для String: capitalize(), isEmail(), reverse().
*/
extension StringUtils on String {
  String capitalize() {
    if (this.isEmpty) return '';
    final lower = this.toLowerCase();

    return this[0].toUpperCase() + lower.substring(1);
  }

  bool isEmail() {
    var regExp = RegExp(r'^[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\-\.]+\.[a-zA-Z]{2,}$');

    return regExp.hasMatch(this);
  }

  String reverse() {
    return this.split('').reversed.join('');
  }
}