String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }

  return '${minutes}m';
}

String formatTime(DateTime time) {
  final hour = time.hour > 12
      ? time.hour - 12
      : time.hour == 0
      ? 12
      : time.hour;

  final minute =
  time.minute.toString().padLeft(2, '0');

  final period = time.hour >= 12 ? 'PM' : 'AM';

  return '$hour:$minute $period';
}