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

  // ── Auth ──────────────────────────────────────────────────────────────

  bool get isAuthenticated => _pb.authStore.isValid;

  String? get currentUserId => _pb.authStore.record?.id;

  Future<RecordAuth> login(String email, String password) async {
    return await _pb.collection('users').authWithPassword(email, password);
  }

  Future<void> register(String email, String password) async {
    await _pb.collection('users').create(body: {
      'email': email,
      'password': password,
      'passwordConfirm': password,
    });
    await _pb.collection('users').authWithPassword(email, password);
  }

  void logout() {
    _pb.authStore.clear();
  }

  // ── Recalls ───────────────────────────────────────────────────────────

  Future<List<Recall>> getRecallsByBarcode(String barcode) async {
    final result = await _pb.collection('rappels_produits').getList(
      filter: 'gtin = "$barcode" && is_active = true',
    );

    return result.items
        .map((record) => Recall.fromJson(record.toJson()))
        .toList();
  }

  // ── History ───────────────────────────────────────────────────────────

  Future<void> saveToHistory({
    required String barcode,
    String? productName,
    String? picture,
    String? brands,
    String? nutriScore,
  }) async {
    final base = {
      'user': currentUserId,
      'barcode': barcode,
      'product_name': productName ?? '',
      'picture': picture ?? '',
      'brands': brands ?? '',
    };

    try {
      await _pb.collection('historique').create(body: {
        ...base,
        'nutri_score': nutriScore ?? '',
      });
    } on ClientException {
      // Le champ nutri_score n'existe peut-être pas encore dans PocketBase
      await _pb.collection('historique').create(body: base);
    }
  }

  Future<List<RecordModel>> getHistory() async {
    final result = await _pb.collection('historique').getList(
      sort: '-created',
      filter: 'user = "$currentUserId"',
    );
    return result.items;
  }

  // ── Favorites ─────────────────────────────────────────────────────────

  Future<void> addFavorite({
    required String barcode,
    String? productName,
    String? picture,
    String? brands,
    String? nutriScore,
  }) async {
    final base = {
      'user': currentUserId,
      'barcode': barcode,
      'product_name': productName ?? '',
      'picture': picture ?? '',
      'brands': brands ?? '',
    };

    try {
      await _pb.collection('favoris').create(body: {
        ...base,
        'nutri_score': nutriScore ?? '',
      });
    } on ClientException {
      await _pb.collection('favoris').create(body: base);
    }
  }

  Future<void> removeFavorite(String barcode) async {
    final result = await _pb.collection('favoris').getList(
      filter: 'user = "$currentUserId" && barcode = "$barcode"',
    );
    for (final item in result.items) {
      await _pb.collection('favoris').delete(item.id);
    }
  }

  Future<bool> isFavorite(String barcode) async {
    final result = await _pb.collection('favoris').getList(
      filter: 'user = "$currentUserId" && barcode = "$barcode"',
    );
    return result.items.isNotEmpty;
  }

  Future<List<RecordModel>> getFavorites() async {
    final result = await _pb.collection('favoris').getList(
      sort: '-created',
      filter: 'user = "$currentUserId"',
    );
    return result.items;
  }
}
