import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../services/adhan_scheduler.dart';
import '../../../../theme/app_theme.dart';

/// Developer-only screen for testing the adhan pipeline.
///
/// This screen is ONLY reachable in debug/profile builds.
/// It schedules a test adhan alarm using the exact same pipeline as a real
/// prayer: AlarmManager → BroadcastReceiver → ForegroundService → Audio.
///
/// Access: Settings screen → long-press "About" tile → Developer Test Mode.
class AdhanTestScreen extends StatefulWidget {
  const AdhanTestScreen({super.key});

  @override
  State<AdhanTestScreen> createState() => _AdhanTestScreenState();
}

class _AdhanTestScreenState extends State<AdhanTestScreen> {
  bool _isScheduled = false;
  int? _scheduledSeconds;
  int _countdown = 0;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _scheduleTest(int delaySeconds) async {
    _countdownTimer?.cancel();

    await AdhanScheduler.instance.scheduleTestAlarm(delaySeconds);

    if (!mounted) return;
    setState(() {
      _isScheduled = true;
      _scheduledSeconds = delaySeconds;
      _countdown = delaySeconds;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _countdown--;
        if (_countdown <= 0) {
          timer.cancel();
          _isScheduled = false;
          _scheduledSeconds = null;
        }
      });
    });
  }

  void _cancelTest() {
    _countdownTimer?.cancel();
    AdhanScheduler.instance.stopAdhan();
    setState(() {
      _isScheduled = false;
      _scheduledSeconds = null;
      _countdown = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: const Text(
          'Adhan Test Mode',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.bgPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Debug only — NOT visible in release builds.\n'
                      'Uses the exact same pipeline as a real prayer.',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Status
            if (_isScheduled) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Test alarm scheduled',
                      style: TextStyle(
                        color: Colors.blue[200],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_countdown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'seconds until adhan plays',
                      style: TextStyle(
                        color: Colors.blue[300],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Alarm: $_scheduledSeconds秒 → AlarmManager → Receiver → Service → Audio',
                      style: TextStyle(
                        color: Colors.blue[300],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _cancelTest,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel Test'),
                ),
              ),
            ] else ...[
              // Test buttons
              const Text(
                'Schedule test adhan:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _buildTestButton(15, '15 seconds', Colors.green),
              const SizedBox(height: 8),
              _buildTestButton(30, '30 seconds', Colors.blue),
              const SizedBox(height: 8),
              _buildTestButton(60, '60 seconds', Colors.purple),
            ],

            const Spacer(),

            // Pipeline info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Pipeline: scheduleTestAlarm() → setAlarmClock()\n'
                '→ AdhanAlarmReceiver.onReceive()\n'
                '→ startForegroundService()\n'
                '→ AdhanForegroundService.playAdhan()\n'
                '→ MediaPlayer(USAGE_ALARM)\n'
                '→ Notification + Audio Playback',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(int seconds, String label, Color color) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () => _scheduleTest(seconds),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.2),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline, color: color),
            const SizedBox(width: 8),
            Text(
              'Test in $label',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
