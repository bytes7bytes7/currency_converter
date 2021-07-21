import 'dart:async';

import '../models/currency.dart';
import '../repositories/exchange_repository.dart';

abstract class ExchangeBloc {
  static final ExchangeRepository _repository = ExchangeRepository();
  static final StreamController<ExchangeState> _exchangeStreamController =
      StreamController<ExchangeState>();

  static Stream<ExchangeState> get exchange {
    return _exchangeStreamController.stream;
  }

  // void dispose() {
  //   if(!_exchangeStreamController.isClosed) {
  //     _exchangeStreamController.close();
  //   }
  // }

  static void updateExchanges() async {
    _exchangeStreamController.sink.add(ExchangeState._exchangeLoading());
    _repository.updateExchanges().then((List<Currency> currencyList) {
      currencyList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      _repository.getLastDate().then((date) {
        if (!_exchangeStreamController.isClosed) {
          _exchangeStreamController.sink
              .add(ExchangeState._exchangeData(currencyList, date));
        }
      }).onError((Error error,StackTrace stackTrace) {
        if (!_exchangeStreamController.isClosed) {
          _exchangeStreamController.sink
              .add(ExchangeState._exchangeError(error, stackTrace));
        }
      });
    }).onError((Error error, StackTrace stackTrace) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink
            .add(ExchangeState._exchangeError(error, stackTrace));
      }
    });
  }

  static void loadAllExchanges() async {
    _exchangeStreamController.sink.add(ExchangeState._exchangeLoading());
    _repository.getAllCurrencies().then((List<Currency> currencyList) {
      currencyList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      _repository.getLastDate().then((date) {
        if (!_exchangeStreamController.isClosed) {
          _exchangeStreamController.sink
              .add(ExchangeState._exchangeData(currencyList, date));
        }
      }).onError((Error error,StackTrace stackTrace) {
        if (!_exchangeStreamController.isClosed) {
          _exchangeStreamController.sink
              .add(ExchangeState._exchangeError(error, stackTrace));
        }
      });
    }).onError((Error error, StackTrace stackTrace) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink
            .add(ExchangeState._exchangeError(error, stackTrace));
      }
    });
  }
}

class ExchangeState {
  ExchangeState();

  factory ExchangeState._exchangeData(List<Currency> currencies, String date) =
      ExchangeDataState;

  factory ExchangeState._exchangeLoading() = ExchangeLoadingState;

  factory ExchangeState._exchangeError(Error error, StackTrace stackTrace) =
      ExchangeErrorState;
}

class ExchangeInitState extends ExchangeState {}

class ExchangeLoadingState extends ExchangeState {}

class ExchangeErrorState extends ExchangeState {
  ExchangeErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class ExchangeDataState extends ExchangeState {
  ExchangeDataState(this.currencies, this.date);

  final List<Currency> currencies;
  final String date;
}
