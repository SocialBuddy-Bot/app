class AnimationState {
  const AnimationState._(this._value);

  static const closed = AnimationState._('closed');
  static const awakened = AnimationState._('awakened');
  static const happy = AnimationState._('happy');
  static const sad = AnimationState._('sad');

  static List<AnimationState> get values => [
        closed,
        awakened,
        happy,
        sad,
      ];

  final String _value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is AnimationState && runtimeType == other.runtimeType) {
      return _value == other._value;
    }
    if (other is String) {
      return _value == other;
    }
    return false;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return _value;
  }
}
