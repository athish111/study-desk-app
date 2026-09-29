import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  static const int focusDuration = 25 * 60;
  static const int shortBreak = 5 * 60;
  static const int longBreak = 15 * 60;

  int _remainingSeconds = focusDuration;
  int _totalSeconds = focusDuration;
  bool _isRunning = false;
  int _sessionCount = 0;
  Timer? _timer;
  String _mode = 'Focus';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        _onComplete();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _onComplete() {
    setState(() => _isRunning = false);
    if (_mode == 'Focus') {
      _sessionCount++;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$_mode session completed!')),
    );
    _resetTimer();
  }

  void _changeMode(String mode, int seconds) {
    _timer?.cancel();
    setState(() {
      _mode = mode;
      _remainingSeconds = seconds;
      _totalSeconds = seconds;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remainingSeconds / _totalSeconds;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;

    final double circleSize = context.isDesktop
        ? 340
        : context.isTablet
            ? 300
            : 260;

    return Scaffold(
      appBar: AppBar(title: const Text('Focus Timer')),
      body: ResponsiveCenter(
        maxWidth: 600,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPadding,
            vertical: 24,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _modeChip('Focus', focusDuration),
                  const SizedBox(width: 8),
                  _modeChip('Short Break', shortBreak),
                  const SizedBox(width: 8),
                  _modeChip('Long Break', longBreak),
                ],
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: _isRunning
                          ? [
                              BoxShadow(
                                color: primary.withOpacity(
                                    0.2 + _pulseController.value * 0.2),
                                blurRadius: 40,
                                spreadRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: primary.withOpacity(0.12),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primary),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _mode,
                              style: TextStyle(
                                fontSize: context.sp(14),
                                letterSpacing: 2,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatTime(_remainingSeconds),
                              style: TextStyle(
                                fontSize: context.sp(64),
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark ? Colors.white : Colors.black87,
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Session ${_sessionCount + 1}',
                              style: TextStyle(
                                fontSize: context.sp(12),
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleButton(
                    icon: Icons.refresh,
                    onTap: _resetTimer,
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: _isRunning ? _pauseTimer : _startTimer,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  _circleButton(
                    icon: Icons.skip_next,
                    onTap: () => _onComplete(),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF252540) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statsColumn(
                        '$_sessionCount', 'Sessions', Icons.check_circle),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade400.withOpacity(0.3),
                    ),
                    _statsColumn('${_sessionCount * 25}m', 'Focus time',
                        Icons.timer_outlined),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade400.withOpacity(0.3),
                    ),
                    _statsColumn('${_sessionCount * 25}', 'Minutes',
                        Icons.hourglass_empty),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeChip(String label, int seconds) {
    final isSelected = _mode == label;
    return GestureDetector(
      onTap: () => _changeMode(label, seconds),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade400,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252540) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 24),
      ),
    );
  }

  Widget _statsColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon,
            size: 18, color: Theme.of(context).primaryColor),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style:
                TextStyle(fontSize: 10, color: Colors.grey.shade600)),
      ],
    );
  }
}