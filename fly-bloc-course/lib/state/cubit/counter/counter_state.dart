part of 'counter_cubit.dart';

class CounterState extends Equatable {
  final int value;
  final bool wasIncremented;

  const CounterState(this.value, this.wasIncremented);

  @override
  String toString() {
    return 'CounterState{value: $value, wasIncremented: $wasIncremented}';
  }

  @override
  List<Object?> get props => [value, wasIncremented];

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'wasIncremented': wasIncremented,
    };
  }

  factory CounterState.fromMap(Map<String, dynamic> map) {
    return CounterState(
      map['value'] as int,
      map['wasIncremented'] as bool,
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory CounterState.fromJson(String source) {
    return CounterState.fromMap(json.decode(source));
  }
}
