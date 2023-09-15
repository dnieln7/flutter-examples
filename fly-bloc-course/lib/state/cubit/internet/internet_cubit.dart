import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fly_bloc_course/state/constants/enums.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;

  StreamSubscription? _subscription;

  InternetCubit(this.connectivity) : super(InternetLoading()) {
    _subscription = connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.wifi) {
        onInternetConnected(ConnectionType.wifi);
      }
      if (result == ConnectivityResult.mobile) {
        onInternetConnected(ConnectionType.mobile);
      }
      if (result == ConnectivityResult.none) {
        onInternetDisconnected();
      }
    });
  }

  void onInternetConnected(ConnectionType type) {
    emit(InternetConnected(type));
  }

  void onInternetDisconnected() {
    emit(InternetDisconnected());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();

    return super.close();
  }
}
