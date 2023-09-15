import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/cubit/counter/counter_cubit.dart';

class CounterNegativeScreen extends StatelessWidget {
  static const path = '/counter/negative';

  const CounterNegativeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter negative')),
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
            onPressed: context.read<CounterCubit>().decrement,
            child: const Text('-'),
          ),
        ],
      ),
    );
  }
}
