extension DurationExtension on Duration {
  String get format {
    return "$inMinutes:${inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }
}
