import 'package:flutter_bloc/flutter_bloc.dart';

// Debugs all cubits and blocs
// Must override toString on Blocs and Cubits
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print('onCreate => $bloc');
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    print('onClose => $bloc');
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError => $bloc => $error => $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('onError => $bloc => $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print('onError => $bloc => $change');
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    print('onError => $bloc => $event');
    super.onEvent(bloc, event);
  }
}
