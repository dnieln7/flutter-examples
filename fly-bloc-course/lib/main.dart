import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fly_bloc_course/state/cubit/counter/counter_cubit.dart';
import 'package:fly_bloc_course/state/cubit/internet/internet_cubit.dart';
import 'package:fly_bloc_course/state/utils/app_bloc_observer.dart';
import 'package:fly_bloc_course/ui/router/app_router.dart';
import 'package:fly_bloc_course/ui/screen/counter_screen.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // Bloc.observer = AppBlocObserver(); for debug only

  HydratedBlocOverrides.runZoned(
    () => runApp(FlyBloc(Connectivity())),
    storage: storage,
  );
}

class FlyBloc extends StatelessWidget {
  final Connectivity connectivity;
  final AppRouter _router = AppRouter();

  FlyBloc(this.connectivity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => InternetCubit(connectivity)),
        BlocProvider(
          create: (ctx) => CounterCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Fly Bloc Course',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            accentColor: Colors.yellowAccent,
          ),
        ),
        initialRoute: CounterScreen.path,
        onGenerateRoute: _router.onGenerateRoute,
      ),
    );
  }
}
