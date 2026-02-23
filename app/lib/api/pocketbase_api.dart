import 'dart:io' show Platform;
import 'package:pocketbase/pocketbase.dart';
import 'package:formation_flutter/model/recall.dart';

class PocketBaseAPI {
  // Android emulator: 10.0.2.2 | iOS simulator / desktop: 127.0.0.1
  static final String _baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8090'
      : 'http://127.0.0.1:8090';

  static final PocketBaseAPI _instance = PocketBaseAPI._internal();

  factory PocketBaseAPI() => _instance;

  final PocketBase _pb;

  PocketBaseAPI._internal() : _pb = PocketBase(_baseUrl);

  Future<List<Recall>> getRecallsByBarcode(String barcode) async {
    final result = await _pb.collection('rappels_produits').getList(
      filter: 'gtin = "$barcode" && is_active = true',
    );

    return result.items
        .map((record) => Recall.fromJson(record.toJson()))
        .toList();
  }
}
