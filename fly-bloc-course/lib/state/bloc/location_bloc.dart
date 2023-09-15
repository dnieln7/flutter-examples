import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'location_event.dart';

part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(const LocationState(0, 0, 0, 0)) {
    on<LocationEvent>((event, emit) {
      if (event is FromGps) {
        emit(LocationState(event.x, event.y, event.z, 1));
      }
      if (event is FromWifi) {
        emit(
          LocationState(
            event.rawCoordinates.length.toDouble(),
            event.rawCoordinates.length.toDouble(),
            event.rawCoordinates.length.toDouble(),
            0.5,
          ),
        );
      }
    });
  }

  // Debug events
  @override
  void onEvent(LocationEvent event) {
    print(event);
    super.onEvent(event);
  }

  // Debug events
  @override
  void onChange(Change<LocationState> change) {
    print(change);
    super.onChange(change);
  }

  // Combine onEvent & onChange
  @override
  void onTransition(Transition<LocationEvent, LocationState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
