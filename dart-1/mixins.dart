/*
Создать интерфейсы Flyable, Swimmable, Walkable; классы Duck (все три) и Penguin (два из трёх).
*/

mixin class Flyable {
  void fly() {
    print('Fly!');
  }
}

mixin class Swimmable {
  void swimm() {
    print('Swimm!');
  }
}
mixin class Walkable {
  void walk() {
    print('Walk!');
  }
}

class Duck with Flyable, Swimmable, Walkable {}

class Penguin with Swimmable, Walkable {}