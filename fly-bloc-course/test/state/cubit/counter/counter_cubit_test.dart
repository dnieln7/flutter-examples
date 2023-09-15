import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fly_bloc_course/state/cubit/counter/counter_cubit.dart';

void main() {
  group('Counter Cubit', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = CounterCubit();
    });

    test('The initial state is 0 and false', () {
      expect(counterCubit.state, CounterState(0, false));
    });

    blocTest<CounterCubit, CounterState>(
      'When increment() is called cubit should emit a state with a value of one and wasIncremented on true',
      build: () => counterCubit,
      act: (cubit) {
        cubit.increment();
      },
      expect: () => <CounterState>[CounterState(1, true)],
    );

    blocTest<CounterCubit, CounterState>(
      'When decrement() is called cubit should emit a state with a value of -1 and wasIncremented on false',
      build: () => counterCubit,
      act: (cubit) {
        cubit.decrement();
      },
      expect: () => <CounterState>[CounterState(-1, false)],
    );

    tearDown(() {
      counterCubit.close();
    });
  });
}
