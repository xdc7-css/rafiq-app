import 'dart:convert';

class PersistedPlaybackState {
  final int currentSurahNumber;
  final String currentSurahName;
  final int? reciterId;
  final String reciterName;
  final int? moshafId;
  final String moshafName;
  final String server;
  final int currentIndex;
  final int positionMs;
  final double speed;
  final int loopModeIndex;
  final bool shuffle;
  final List<QueueItem> queue;
  final DateTime savedAt;

  const PersistedPlaybackState({
    required this.currentSurahNumber,
    required this.currentSurahName,
    this.reciterId,
    required this.reciterName,
    this.moshafId,
    required this.moshafName,
    required this.server,
    required this.currentIndex,
    required this.positionMs,
    required this.speed,
    required this.loopModeIndex,
    required this.shuffle,
    required this.queue,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'currentSurahNumber': currentSurahNumber,
        'currentSurahName': currentSurahName,
        'reciterId': reciterId,
        'reciterName': reciterName,
        'moshafId': moshafId,
        'moshafName': moshafName,
        'server': server,
        'currentIndex': currentIndex,
        'positionMs': positionMs,
        'speed': speed,
        'loopModeIndex': loopModeIndex,
        'shuffle': shuffle,
        'queue': queue.map((e) => e.toJson()).toList(),
        'savedAt': savedAt.toIso8601String(),
      };

  factory PersistedPlaybackState.fromJson(Map<String, dynamic> json) {
    return PersistedPlaybackState(
      currentSurahNumber: json['currentSurahNumber'] as int? ?? 1,
      currentSurahName: json['currentSurahName'] as String? ?? 'الفاتحة',
      reciterId: json['reciterId'] as int?,
      reciterName: json['reciterName'] as String? ?? '',
      moshafId: json['moshafId'] as int?,
      moshafName: json['moshafName'] as String? ?? '',
      server: json['server'] as String? ?? '',
      currentIndex: json['currentIndex'] as int? ?? 0,
      positionMs: json['positionMs'] as int? ?? 0,
      speed: (json['speed'] as num?)?.toDouble() ?? 1.0,
      loopModeIndex: json['loopModeIndex'] as int? ?? 0,
      shuffle: json['shuffle'] as bool? ?? false,
      queue: (json['queue'] as List<dynamic>?)
              ?.map((e) =>
                  QueueItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      savedAt: DateTime.tryParse(json['savedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  String encode() => json.encode(toJson());

  factory PersistedPlaybackState.decode(String source) {
    return PersistedPlaybackState.fromJson(
        json.decode(source) as Map<String, dynamic>);
  }

  Duration get position => Duration(milliseconds: positionMs);
}

class QueueItem {
  final int surahNumber;
  final String surahName;
  final String audioUrl;
  final String? localPath;

  const QueueItem({
    required this.surahNumber,
    required this.surahName,
    required this.audioUrl,
    this.localPath,
  });

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'audioUrl': audioUrl,
        'localPath': localPath,
      };

  factory QueueItem.fromJson(Map<String, dynamic> json) {
    return QueueItem(
      surahNumber: json['surahNumber'] as int? ?? 1,
      surahName: json['surahName'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
      localPath: json['localPath'] as String?,
    );
  }
}
