import 'dart:math' as math;

class QiblaMath {
  QiblaMath._();

  static double toRadians(double degrees) => degrees * math.pi / 180;
  static double toDegrees(double radians) => radians * 180 / math.pi;

  static double normalizeAngle(double angle) {
    var result = angle % 360;
    if (result < 0) result += 360;
    return result;
  }

  static double normalizeAngleRad(double angle) {
    var result = angle % (2 * math.pi);
    if (result < 0) result += 2 * math.pi;
    return result;
  }

  static double angularDifference(double a, double b) {
    final diff = (a - b).abs() % 360;
    return diff > 180 ? 360 - diff : diff;
  }

  static double shortestRotationFromTo(double from, double to) {
    var diff = to - from;
    while (diff > 180) {
      diff -= 360;
    }
    while (diff < -180) {
      diff += 360;
    }
    return diff;
  }

  static String formatDegrees(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}°';
  }

  static String formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} م';
    return '${km.toStringAsFixed(0)} كم';
  }

  static String cardinalDirection(double bearing) {
    final dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((bearing + 22.5) % 360 / 45).floor();
    return dirs[index % 8];
  }

  static double angularDiffFromNorth(double qiblaBearing, double heading) {
    return (qiblaBearing - heading + 360) % 360;
  }
}
