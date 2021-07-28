import 'dart:async';

import '../models/setting.dart';
import '../repositories/setting_repository.dart';
import '../global_parameters.dart';

abstract class SetupBloc {
  static final StreamController<SetupState> _setupStreamController =
      StreamController<SetupState>.broadcast();

  static Stream<SetupState> get setup {
    return _setupStreamController.stream;
  }

  // void dispose() {
  //   if(!_settingStreamController.isClosed) {
  //     _settingStreamController.close();
  //   }
  // }

  static Future<void> setupAllSettings() async {
    _setupStreamController.sink.add(SetupState._setupLoading());
    SettingRepository.getSettings().then((List<Setting> settings) {
      GlobalParameters.allSettings.clear();
      GlobalParameters.allSettings.addAll(settings);
      if (!_setupStreamController.isClosed) {
        _setupStreamController.sink.add(SetupState._setupData(settings));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_setupStreamController.isClosed) {
        _setupStreamController.sink
            .add(SetupState._setupError(error, stackTrace));
      }
    });
  }

  static Future<void> addDefaultSettings()async{
    _setupStreamController.sink.add(SetupState._setupLoading());
    SettingRepository.addDefaultSettings().then((List<Setting> settings) {
      GlobalParameters.allSettings.clear();
      GlobalParameters.allSettings.addAll(settings);
      if (!_setupStreamController.isClosed) {
        _setupStreamController.sink.add(SetupState._setupData(settings));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_setupStreamController.isClosed) {
        _setupStreamController.sink
            .add(SetupState._setupError(error, stackTrace));
      }
    });
  }
}

class SetupState {
  SetupState();

  factory SetupState._setupData(List<Setting> settings) = SetupDataState;

  factory SetupState._setupLoading() = SetupLoadingState;

  factory SetupState._setupError(Error error, StackTrace stackTrace) =
      SetupErrorState;
}

class SetupInitState extends SetupState {}

class SetupLoadingState extends SetupState {}

class SetupErrorState extends SetupState {
  SetupErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class SetupDataState extends SetupState {
  SetupDataState(this.setup);

  final List<Setting> setup;
}
