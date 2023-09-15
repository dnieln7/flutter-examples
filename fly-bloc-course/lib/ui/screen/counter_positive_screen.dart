import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fly_bloc_course/state/cubit/internet/internet_cubit.dart';

import '../../state/cubit/counter/counter_cubit.dart';

class CounterPositiveScreen extends StatelessWidget {
  static const path = '/counter/positive';

  const CounterPositiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter positive')),
      body: Column(
        children: [
          BlocBuilder<CounterCubit, CounterState>(
            builder: (context, state) {
              return Text(
                state.value.toString(),
                textAlign: TextAlign.center,
              );
            },
          ),
          ElevatedButton(
            onPressed: context
                .read<CounterCubit>()
                .increment, // Same as Provider.of with listen to false
            child: const Text('+'),
          ),
          Builder( // Equivalent of BlocSelector widget
            builder: (ctx) {
              final value = ctx.select(
                (CounterCubit cubit) => cubit.state.wasIncremented,
              ); // Listen only to a property

              return Text(
                'new wasIncremented -> $value is different from previous',
              );
            },
          ),
          Builder( // Equivalent to BlocBuilder
            builder: (ctx) {
              final counterState =
                  ctx.watch<CounterCubit>().state; // Listen all state
              final internetState = ctx.watch<InternetCubit>().state;

              return Text(
                'Counter: ${counterState.value} Internet: ${internetState.toString()}',
              );
            },
          ),
        ],
      ),
    );
  }
}
