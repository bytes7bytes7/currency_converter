import 'dart:async';

import '../repositories/info_repository.dart';

abstract class InfoBloc {
  static final StreamController<InfoState> _infoStreamController =
      StreamController<InfoState>();

  static Stream<InfoState> get info {
    return _infoStreamController.stream;
  }

  // void dispose() {
  //   if(!_infoStreamController.isClosed) {
  //     _infoStreamController.close();
  //   }
  // }

  static void getLastDate() async {
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

  static void singLoading() {
    _infoStreamController.sink.add(InfoState._infoLoading());
  }
}

class InfoState {
  InfoState();

  factory InfoState._infoData(String date) = InfoDataState;

  factory InfoState._infoLoading() = InfoLoadingState;

  factory InfoState._infoError(Error error, StackTrace stackTrace) =
      InfoErrorState;
}

class InfoInitState extends InfoState {}

class InfoLoadingState extends InfoState {}

class InfoErrorState extends InfoState {
  InfoErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class InfoDataState extends InfoState {
  InfoDataState(this.date);

  final String date;
}
