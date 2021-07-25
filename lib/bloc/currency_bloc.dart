import 'dart:async';

import '../bloc/info_bloc.dart';
import '../repositories/currency_repository.dart';
import '../models/currency.dart';

abstract class CurrencyBloc {
  static final StreamController<CurrencyState> _currencyStreamController =
      StreamController<CurrencyState>.broadcast();

  static Stream<CurrencyState> get currency {
    return _currencyStreamController.stream;
  }

  // void dispose() {
  //   if(!_currencyStreamController.isClosed) {
  //     _currencyStreamController.close();
  //   }
  // }

  static Future<void> updateCurrencies() async {
    InfoBloc.sinkLoading();
    _currencyStreamController.sink.add(CurrencyState._currencyLoading());
    CurrencyRepository.updateCurrencies().then((List<Currency> currencyList) {
      if(currencyList.isEmpty){
        InfoBloc.sinkError();
      }
      currencyList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      InfoBloc.getLastDate();
      if (!_currencyStreamController.isClosed) {
        _currencyStreamController.sink
            .add(CurrencyState._currencyData(currencyList));
      }
    }).onError((Error error, StackTrace stackTrace) {
      InfoBloc.sinkError();
      if (!_currencyStreamController.isClosed) {
        _currencyStreamController.sink
            .add(CurrencyState._currencyError(error, stackTrace));
      }
    });
  }

  static Future<void> loadAllCurrencies() async {
    _currencyStreamController.sink.add(CurrencyState._currencyLoading());
    CurrencyRepository.getAllCurrencies().then((List<Currency> currencyList) {
      currencyList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      if (!_currencyStreamController.isClosed) {
        _currencyStreamController.sink
            .add(CurrencyState._currencyData(currencyList));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_currencyStreamController.isClosed) {
        _currencyStreamController.sink
            .add(CurrencyState._currencyError(error, stackTrace));
      }
    });
  }
}

class CurrencyState {
  CurrencyState();

  factory CurrencyState._currencyData(List<Currency> currencies) =
      CurrencyDataState;

  factory CurrencyState._currencyLoading() = CurrencyLoadingState;

  factory CurrencyState._currencyError(Error error, StackTrace stackTrace) =
      CurrencyErrorState;
}

class CurrencyInitState extends CurrencyState {}

class CurrencyLoadingState extends CurrencyState {}

class CurrencyErrorState extends CurrencyState {
  CurrencyErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class CurrencyDataState extends CurrencyState {
  CurrencyDataState(this.currencies);

  final List<Currency> currencies;
}
