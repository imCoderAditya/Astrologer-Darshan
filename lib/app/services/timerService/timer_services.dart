import 'dart:async';

import 'package:flutter/material.dart';

class TimerService {
  Timer? _timer;

  void startTimer({
    required int endTimeInMinutes,
    required Function(Duration remaining) onTick,
    required VoidCallback onComplete,
  }) {
    _timer?.cancel();

    final endTime = DateTime.now().add(Duration(minutes: endTimeInMinutes));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final diff = endTime.difference(now);

      if (diff.isNegative) {
        timer.cancel();
        onComplete();
      } else {
        onTick(diff);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
