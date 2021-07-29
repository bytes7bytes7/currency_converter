import 'dart:async';

import '../models/exchange.dart';
import '../repositories/exchange_repository.dart';

abstract class HistoryBloc {
  static final StreamController<HistoryState> _historyStreamController =
      StreamController<HistoryState>.broadcast();

  static Stream<HistoryState> get history {
    return _historyStreamController.stream;
  }


  static Future<void> addExchange(Exchange exchange) async {
    _historyStreamController.sink.add(HistoryState._exchangeLoading());
    ExchangeRepository.addExchange(exchange)
        .onError((Error error, StackTrace stackTrace) {
      if (!_historyStreamController.isClosed) {
        _historyStreamController.sink
            .add(HistoryState._exchangeError(error, stackTrace));
      }
    });
  }

  static Future<void> getAllExchanges() async {
    _historyStreamController.sink.add(HistoryState._exchangeLoading());
    ExchangeRepository.getAllExchanges().then((List<Exchange> exchanges) {
      exchanges = List.from(exchanges.reversed);
      if (!_historyStreamController.isClosed) {
        _historyStreamController.sink
            .add(HistoryState._exchangeData(exchanges));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_historyStreamController.isClosed) {
        _historyStreamController.sink
            .add(HistoryState._exchangeError(error, stackTrace));
      }
    });
  }

  static Future<void> deleteAllExchanges()async{
    _historyStreamController.sink.add(HistoryState._exchangeLoading());
    ExchangeRepository.deleteAllExchanges().then((_) {
      if (!_historyStreamController.isClosed) {
        _historyStreamController.sink
            .add(HistoryState._exchangeData(<Exchange>[]));
      }
    }).onError((Error error, StackTrace stackTrace) {
      if (!_historyStreamController.isClosed) {
        _historyStreamController.sink
            .add(HistoryState._exchangeError(error, stackTrace));
      }
    });
  }
}

class HistoryState {
  HistoryState();

  factory HistoryState._exchangeData(List<Exchange> exchanges) =
      HistoryDataState;

  factory HistoryState._exchangeLoading() = HistoryLoadingState;

  factory HistoryState._exchangeError(Error error, StackTrace stackTrace) =
      HistoryErrorState;
}

class HistoryInitState extends HistoryState {}

class HistoryLoadingState extends HistoryState {}

class HistoryErrorState extends HistoryState {
  HistoryErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class HistoryDataState extends HistoryState {
  HistoryDataState(this.exchanges);

  final List<Exchange> exchanges;
}
