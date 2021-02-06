String getTimeGreeting() {
  final now = DateTime.now();

  if (now.hour >= 6 && now.hour < 12) {
    return 'Goeiemorgen.';
  }
  if (now.hour >= 12 && now.hour < 18) {
    return 'Goeiemiddag.';
  }
  if (now.hour >= 18) {
    return 'Goeienavond.';
  }
  {
    return 'Goeienacht.';
  }
}
