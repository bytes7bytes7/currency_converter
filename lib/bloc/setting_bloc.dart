import 'dart:async';

import '../models/setting.dart';
import '../repositories/setting_repository.dart';

abstract class SettingBloc {
  static final StreamController<SettingState> _settingStreamController =
      StreamController<SettingState>.broadcast();

  static Stream<SettingState> get setting {
    return _settingStreamController.stream;
  }

  // void dispose() {
  //   if(!_settingStreamController.isClosed) {
  //     _settingStreamController.close();
  //   }
  // }

  static Future<void> getSettings() async {
    _settingStreamController.sink.add(SettingState._settingLoading());
    SettingRepository.getSettings().then((List<Setting> settings) {
      if (!_settingStreamController.isClosed) {
        _settingStreamController.sink.add(SettingState._settingData(settings));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_settingStreamController.isClosed) {
        _settingStreamController.sink
            .add(SettingState._settingError(error, stackTrace));
      }
    });
  }

  static Future<void> addDefaultSettings()async{
    _settingStreamController.sink.add(SettingState._settingLoading());
    SettingRepository.addDefaultSettings().then((List<Setting> settings) {
      if (!_settingStreamController.isClosed) {
        _settingStreamController.sink.add(SettingState._settingData(settings));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_settingStreamController.isClosed) {
        _settingStreamController.sink
            .add(SettingState._settingError(error, stackTrace));
      }
    });
  }

  static Future<void> updateSettings(List<Setting> settings)async{
    _settingStreamController.sink.add(SettingState._settingLoading());
    SettingRepository.updateSettings(settings).then((_) {
    }).onError((Error error, StackTrace stackTrace) {
      if (!_settingStreamController.isClosed) {
        _settingStreamController.sink
            .add(SettingState._settingError(error, stackTrace));
      }
    });
  }
}

class SettingState {
  SettingState();

  factory SettingState._settingData(List<Setting> settings) = SettingDataState;

  factory SettingState._settingLoading() = SettingLoadingState;

  factory SettingState._settingError(Error error, StackTrace stackTrace) =
      SettingErrorState;
}

class SettingInitState extends SettingState {}

class SettingLoadingState extends SettingState {}

class SettingErrorState extends SettingState {
  SettingErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class SettingDataState extends SettingState {
  SettingDataState(this.settings);

  final List<Setting> settings;
}
