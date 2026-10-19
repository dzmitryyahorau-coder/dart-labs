/*

Реализовать generic-структуры Stack<T> и Queue<T>.

*/

import 'dart:collection';

class Stack<T> {
  List<T> _list = [];

  T? pop() {
    if (_list.isEmpty) return null;
    return _list.removeLast();
  }

  void push(T item) {
    _list.add(item);
  } 

  int get size => _list.length;

  T? get peek => _list.isNotEmpty ? _list.last : null;
}

class Queue<T> {
  DoubleLinkedQueue<T> _queue = DoubleLinkedQueue();

  T? shift() {
    if (_queue.isEmpty) return null;
    return _queue.removeFirst();
  }

  void push(T item) {
    _queue.add(item);
  } 

  int get size => _queue.length;

  T? get peek => _queue.isEmpty ? null : _queue.first;
}