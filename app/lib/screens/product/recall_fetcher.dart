import 'package:flutter/material.dart';
import 'package:formation_flutter/api/pocketbase_api.dart';
import 'package:formation_flutter/model/recall.dart';

class RecallFetcher extends ChangeNotifier {
  RecallFetcher({required String barcode})
    : _barcode = barcode,
      _state = RecallFetcherLoading() {
    loadRecalls();
  }

  final String _barcode;
  RecallFetcherState _state;

  Future<void> loadRecalls() async {
    _state = RecallFetcherLoading();
    notifyListeners();

    try {
      List<Recall> recalls = await PocketBaseAPI().getRecallsByBarcode(_barcode);
      _state = RecallFetcherSuccess(recalls);
    } catch (error) {
      _state = RecallFetcherError(error);
    } finally {
      notifyListeners();
    }
  }

  RecallFetcherState get state => _state;
}

sealed class RecallFetcherState {}

class RecallFetcherLoading extends RecallFetcherState {}

class RecallFetcherSuccess extends RecallFetcherState {
  RecallFetcherSuccess(this.recalls);

  final List<Recall> recalls;

  bool get hasRecalls => recalls.isNotEmpty;
}

class RecallFetcherError extends RecallFetcherState {
  RecallFetcherError(this.error);

  final dynamic error;
}
