/*
Создать Student с полями name, grade, переопределить операторы сравнения для сортировки.
*/

class Student implements Comparable<Student> {
  final String name;
  final int grade;

  const Student(this.name, this.grade);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Student && this.name == other.name && this.grade == other.grade;
  }

  bool operator >(Student other) {
    return this.grade > other.grade;
  }

  bool operator <(Student other) {
    return this.grade < other.grade;
  }

  bool operator >=(Student other) => this > other || this == other;
  bool operator <=(Student other) => this < other || this == other;

  @override
  int get hashCode => Object.hash(name, grade);

  @override
  int compareTo(Student other) {
    if (this.grade != other.grade) {
      return this.grade.compareTo(other.grade);
    }

    return this.name.compareTo(other.name);
  }

  @override
  String toString() {
    return '($name, $grade)';
  }
}