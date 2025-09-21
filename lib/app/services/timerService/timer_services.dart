import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A service to handle timers that can count up or down.
class TimerService extends GetxService {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  Duration _initialDuration = Duration.zero;
  bool _isCountingUp = false;
  bool _isRunning = false;

  // Reactive variables for UI
  final RxString displayTime = '00:00'.obs;
  final RxBool isRunning = false.obs;
  final RxBool isCompleted = false.obs;
  final RxDouble progress = 0.0.obs;

  // Callbacks
  Function(Duration remaining)? _onTick;
  VoidCallback? _onComplete;
  VoidCallback? _onStart;
  VoidCallback? _onPause;

  /// Start the timer
  ///
  /// [endTimeInMinutes] -> Duration in minutes for countdown
  /// [endTimeInSeconds] -> Additional seconds for countdown  
  /// [onTick] -> called every second with the current duration
  /// [onComplete] -> called when countdown reaches 0
  /// [onStart] -> called when timer starts
  /// [countUp] -> true for counting up, false for counting down
  /// [startFrom] -> optional starting duration
  void startTimer({
    int? endTimeInMinutes,
    int? endTimeInSeconds,
    required Function(Duration remaining) onTick,
    required VoidCallback onComplete,
    VoidCallback? onStart,
    bool countUp = false,
    Duration? startFrom,
  }) {
    // Cancel any existing timer
    stopTimer();

    _isCountingUp = countUp;
    _onTick = onTick;
    _onComplete = onComplete;
    _onStart = onStart;

    // Set initial duration
    if (endTimeInMinutes != null || endTimeInSeconds != null) {
      final minutes = endTimeInMinutes ?? 0;
      final seconds = endTimeInSeconds ?? 0;
      _remaining = Duration(minutes: minutes, seconds: seconds);
      _initialDuration = Duration(minutes: minutes, seconds: seconds);
    } else if (startFrom != null) {
      _remaining = startFrom;
      _initialDuration = startFrom;
    }

    // Validate duration for countdown
    if (!_isCountingUp && _remaining.inSeconds <= 0) {
      debugPrint("TimerService: Cannot start countdown with zero or negative duration");
      return;
    }

    _isRunning = true;
    isRunning.value = true;
    isCompleted.value = false;
    
    // Update initial display and progress
    _updateDisplay();
    _updateProgress();
    
    // Call start callback
    _onStart?.call();
    onTick(_remaining);

    debugPrint("TimerService: Started ${_isCountingUp ? 'counting up' : 'countdown'} - ${_formatDuration(_remaining)}");

    // Start the periodic timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isCountingUp) {
        _remaining += const Duration(seconds: 1);
        _updateDisplay();
        _updateProgress();
        onTick(_remaining);
        
        debugPrint("TimerService: Count up - ${_formatDuration(_remaining)}");
      } else {
        // Countdown logic
        if (_remaining.inSeconds <= 0) {
          _remaining = Duration.zero;
          _completeTimer();
        } else {
          _remaining -= const Duration(seconds: 1);
          _updateDisplay();
          _updateProgress();
          onTick(_remaining);
          
          debugPrint("TimerService: Countdown - ${_formatDuration(_remaining)} remaining");
        }
      }
    });
  }

  /// Pause the timer
  void pauseTimer() {
    if (_timer != null && _isRunning) {
      _timer?.cancel();
      _isRunning = false;
      isRunning.value = false;
      _onPause?.call();
      debugPrint("TimerService: Paused at ${_formatDuration(_remaining)}");
    }
  }

  /// Resume the timer
  void resumeTimer() {
    if (!_isRunning && !isCompleted.value) {
      _isRunning = true;
      isRunning.value = true;
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isCountingUp) {
          _remaining += const Duration(seconds: 1);
          _updateDisplay();
          _updateProgress();
          _onTick?.call(_remaining);
        } else {
          if (_remaining.inSeconds <= 0) {
            _remaining = Duration.zero;
            _completeTimer();
          } else {
            _remaining -= const Duration(seconds: 1);
            _updateDisplay();
            _updateProgress();
            _onTick?.call(_remaining);
          }
        }
      });
      
      debugPrint("TimerService: Resumed at ${_formatDuration(_remaining)}");
    }
  }

  /// Stop the timer completely
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    isRunning.value = false;
    isCompleted.value = false;
    debugPrint("TimerService: Stopped");
  }

  /// Reset timer to initial duration
  void resetTimer() {
    stopTimer();
    _remaining = _initialDuration;
    isCompleted.value = false;
    _updateDisplay();
    _updateProgress();
    debugPrint("TimerService: Reset to ${_formatDuration(_remaining)}");
  }

  /// Increase remaining time (no upper limit)
  void increaseTimer({int minutes = 0, int seconds = 0}) {
    final increase = Duration(minutes: minutes, seconds: seconds);
    _remaining += increase;
    
    // Update initial duration for progress calculation
    if (!_isCountingUp) {
      _initialDuration += increase;
    }
    
    _updateDisplay();
    _updateProgress();
    debugPrint("TimerService: Increased by ${_formatDuration(increase)} - Now: ${_formatDuration(_remaining)}");
  }

  /// Decrease remaining time (won't go below 0)
  void decreaseTimer({int minutes = 0, int seconds = 0}) {
    final decreaseBy = Duration(minutes: minutes, seconds: seconds);
    final newRemaining = _remaining > decreaseBy ? _remaining - decreaseBy : Duration.zero;
    _remaining = newRemaining;
    
    _updateDisplay();
    _updateProgress();
    
    // Complete timer if countdown reaches zero
    if (!_isCountingUp && _remaining.inSeconds <= 0) {
      _completeTimer();
    }
    
    debugPrint("TimerService: Decreased by ${_formatDuration(decreaseBy)} - Now: ${_formatDuration(_remaining)}");
  }

  void _completeTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    isRunning.value = false;
    isCompleted.value = true;
    _remaining = Duration.zero;
    _updateDisplay();
    _updateProgress();
    
    debugPrint("TimerService: Timer completed!");
    _onComplete?.call();
  }

  void _updateDisplay() {
    displayTime.value = _formatDuration(_remaining);
  }

  void _updateProgress() {
    if (_isCountingUp || _initialDuration.inSeconds == 0) {
      progress.value = 0.0; // No meaningful progress for count-up
    } else {
      progress.value = 1.0 - (_remaining.inSeconds / _initialDuration.inSeconds);
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Get current remaining time
  Duration get remainingTime => _remaining;
  
  /// Get initial duration
  Duration get initialDuration => _initialDuration;
  
  /// Check if timer is currently running
  bool get isTimerRunning => _isRunning;
  
  /// Check if timer is paused
  bool get isPaused => !_isRunning && !isCompleted.value && _remaining.inSeconds > 0;
  
  /// Get formatted time string
  String get formattedTime => _formatDuration(_remaining);

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }
}

// Usage Examples:
/*

// Initialize
final timerService = Get.put(TimerService());

// Start 5-minute countdown
timerService.startTimer(
  endTimeInMinutes: 5,
  onTick: (remaining) {
    print("Time remaining: ${remaining.inMinutes}:${remaining.inSeconds % 60}");
  },
  onComplete: () {
    print("Time's up!");
  },
  onStart: () {
    print("Timer started!");
  },
);

// Start count-up timer
timerService.startTimer(
  countUp: true,
  onTick: (elapsed) {
    print("Time elapsed: ${elapsed.inMinutes}:${elapsed.inSeconds % 60}");
  },
  onComplete: () {}, // Won't be called for count-up
);

// In your UI:
Obx(() => Text(timerService.displayTime.value))
Obx(() => LinearProgressIndicator(value: timerService.progress.value))
Obx(() => IconButton(
  icon: Icon(timerService.isRunning.value ? Icons.pause : Icons.play_arrow),
  onPressed: () {
    if (timerService.isRunning.value) {
      timerService.pauseTimer();
    } else {
      timerService.resumeTimer();
    }
  },
))

// Control methods:
timerService.increaseTimer(minutes: 2); // Add 2 minutes
timerService.decreaseTimer(seconds: 30); // Remove 30 seconds
timerService.resetTimer(); // Reset to initial time
timerService.stopTimer(); // Stop completely

*/