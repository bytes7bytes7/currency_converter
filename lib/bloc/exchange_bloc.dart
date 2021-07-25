import 'dart:async';

import '../models/exchange.dart';
import '../repositories/exchange_repository.dart';

abstract class ExchangeBloc {
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

  static Future<void> getLastExchange() async {
    _exchangeStreamController.sink.add(ExchangeState._exchangeLoading());
    ExchangeRepository.getLastExchange().then((exchange) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink.add(ExchangeState._exchangeData(exchange));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink
            .add(ExchangeState._exchangeError(error, stackTrace));
      }
    });
  }

  static Future<void> getLastTwoCurrencies() async {
    _exchangeStreamController.sink.add(ExchangeState._exchangeLoading());
    ExchangeRepository.getLastTwoCurrencies().then((exchange) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink.add(ExchangeState._exchangeData(exchange));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink
            .add(ExchangeState._exchangeError(error, stackTrace));
      }
    });
  }

  static Future<void> getFirstTwoCurrencies() async {
    _exchangeStreamController.sink.add(ExchangeState._exchangeLoading());
    ExchangeRepository.getFirstTwoCurrencies().then((exchange) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink.add(ExchangeState._exchangeData(exchange));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink
            .add(ExchangeState._exchangeError(error, stackTrace));
      }
    });
  }

  static Future<void> updateExchange(Exchange exchange)async{
    _exchangeStreamController.sink.add(ExchangeState._exchangeLoading());
    ExchangeRepository.getTwoCurrencies(exchange).then((Exchange exchange) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink
            .add(ExchangeState._exchangeData(exchange));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_exchangeStreamController.isClosed) {
        _exchangeStreamController.sink
            .add(ExchangeState._exchangeError(error, stackTrace));
      }
    });
  }

  static Future<void> updateCalculation() async {
    _exchangeStreamController.sink.add(ExchangeState._exchangeUpdateCalculation());
  }
}

class ExchangeState {
  ExchangeState();

  factory ExchangeState._exchangeData(Exchange exchange) = ExchangeDataState;

  factory ExchangeState._exchangeLoading() = ExchangeLoadingState;

  factory ExchangeState._exchangeError(Error error, StackTrace stackTrace) =
      ExchangeErrorState;

  factory ExchangeState._exchangeUpdateCalculation() = ExchangeUpdateCalculationState;
}

class ExchangeInitState extends ExchangeState {}

class ExchangeLoadingState extends ExchangeState {}

class ExchangeErrorState extends ExchangeState {
  ExchangeErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class ExchangeUpdateCalculationState extends ExchangeState {}

class ExchangeDataState extends ExchangeState {
  ExchangeDataState(this.exchange);

  final Exchange exchange;
}
