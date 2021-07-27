import 'dart:async';

import '../repositories/info_repository.dart';

abstract class InfoBloc {
  static final StreamController<InfoState> _infoStreamController =
      StreamController<InfoState>.broadcast();

  static Stream<InfoState> get info {
    return _infoStreamController.stream;
  }

  // void dispose() {
  //   if(!_infoStreamController.isClosed) {
  //     _infoStreamController.close();
  //   }
  // }

  static Future<void> getLastDate() async {
    _infoStreamController.sink.add(InfoState._infoLoading());
    InfoRepository.getLastDate().then((date) {
      if (!_infoStreamController.isClosed) {
        _infoStreamController.sink.add(InfoState._infoData(date));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_infoStreamController.isClosed) {
        _infoStreamController.sink.add(InfoState._infoError(error, stackTrace));
      }
    });
  }

  static Future<void> sinkLoading() async {
    _infoStreamController.sink.add(InfoState._infoLoading());
  }

  static Future<void> sinkError() async {
    _infoStreamController.sink.add(InfoState._infoLoadingError());
  }
}

class InfoState {
  InfoState();

  factory InfoState._infoData(String date) = InfoDataState;

  factory InfoState._infoLoading() = InfoLoadingState;

  factory InfoState._infoError(Error error, StackTrace stackTrace) =
      InfoErrorState;

  factory InfoState._infoLoadingError() = InfoLoadingErrorState;
}

class InfoInitState extends InfoState {}

class InfoLoadingState extends InfoState {}

class InfoErrorState extends InfoState {
  InfoErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class InfoLoadingErrorState extends InfoState {
}

class InfoDataState extends InfoState {
  InfoDataState(this.date);

  final String date;
}
