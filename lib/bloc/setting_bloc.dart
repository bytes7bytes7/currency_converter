import 'dart:async';

import '../models/setting.dart';
import '../repositories/setting_repository.dart';

abstract class SettingBloc {
  static final StreamController<SettingState> _settingStreamController =
      StreamController<SettingState>.broadcast();

  static Stream<SettingState> get setting {
    return _settingStreamController.stream;
  }

  static Future<void> updateSettings(List<Setting> settings)async{
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

  factory SettingState._settingError(Error error, StackTrace stackTrace) =
      SettingErrorState;
}

class SettingErrorState extends SettingState {
  SettingErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}
