/*

Реализовать буферизацию потока: накопление в буфер, эмит батчами по размеру или таймауту.

*/

import 'dart:async';

extension StreamBatch<T> on Stream<T> {
  Stream<List<T>> bufferBatch({
    required int maxSize,
    required Duration maxWait,
  }) {
    if (maxSize <= 0)
      throw ArgumentError.value(maxSize, 'maxSize', 'must be > 0');

    late final StreamController<List<T>> controller;
    StreamSubscription<T>? subscription;
    Timer? timer;
    List<T> buffer = <T>[];

    void flush() {
      timer?.cancel();
      timer = null;
      if (buffer.isEmpty) return;
      final batch = <T>[];
      controller.add(batch);
    }

    controller = StreamController<List<T>>(
      onListen: () {
        subscription = listen(
          (item) {
            buffer.add(item);
            if (buffer.length >= maxSize) {
              flush();
            } else {
              timer ??= Timer(maxWait, flush);
            }
          },
          onError: controller.addError,
          onDone: () {
            flush();
            controller.close();
          },
        );
      },
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () {
        timer?.cancel();
        return subscription?.cancel();
      },
    );

    return controller.stream;
  }
}
