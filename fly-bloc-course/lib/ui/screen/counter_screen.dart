import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fly_bloc_course/state/cubit/counter/counter_cubit.dart';
import 'package:fly_bloc_course/state/cubit/internet/internet_cubit.dart';
import 'package:fly_bloc_course/ui/screen/counter_negative_screen.dart';
import 'package:fly_bloc_course/ui/screen/counter_positive_screen.dart';
import 'package:fly_bloc_course/ui/utils/navigation.dart';

class CounterScreen extends StatelessWidget {
  static const path = '/counter';

  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<InternetCubit, InternetState>(
            listener: (_, state) {
              if (state is InternetConnected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('InternetConnected ${state.type}'))
                );
              }
              if (state is InternetDisconnected) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('InternetDisconnected'))
                );
              }
            },
          ),
          BlocListener<CounterCubit, CounterState>(
            listener: (_, state) {
              if (state.wasIncremented) {
                print('Incremented');
              } else {
                print('Decremented');
              }
            },
          ),
        ],
        child: Column(
          children: [
            BlocBuilder<InternetCubit, InternetState>(
              builder: (context, state) {
                if (state is InternetConnected) {
                  return Text('Connected to ${state.type}');
                } else if (state is InternetDisconnected) {
                  return const Text('No internet connection');
                } else {
                  return const LinearProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      context.read<CounterCubit>().decrement();
                    },
                    child: const Text('-')),
                Expanded(
                  child: BlocBuilder<CounterCubit, CounterState>(
                    builder: (context, state) {
                      return Text(
                        state.value.toString(),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: context.read<CounterCubit>().increment,
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, CounterPositiveScreen.path),
              child: const Text('To positive'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, CounterNegativeScreen.path),
              child: const Text('To negative'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget.of(context) -> Find the Widget closest to the provided context
// context have parent, because is widget tree, so it search in context if not found goes to parent and repeats if still not found
// Navigator.of(context)
// Only MaterialApp has navigator so the new screen will be created as a child of MaterialApp and be in the same level
// as the current screen

// When using Provider.of<Type>(context) we specify the type because multiple providers could be found.
// MultiProvider is just a wrap for nesting providers

// Consumer combines listener and builder

// class CounterScreen extends StatelessWidget {
//   const CounterScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Counter')),
//       body: Row(
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 context.read<CounterCubit>().decrement();
//               },
//               child: const Text('-')),
//           Expanded(
//             child: BlocConsumer<CounterCubit, CounterState>(
//               listener: (context, state) {
//                 if (state.wasIncremented) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Incremented!')));
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Decremented!')));
//                 }
//               },
//               builder: (context, state) {
//                 return Text(
//                   state.value.toString(),
//                   textAlign: TextAlign.center,
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//               onPressed: context.read<CounterCubit>().increment,
//               child: const Text('+')),
//         ],
//       ),
//     );
//   }
// }
