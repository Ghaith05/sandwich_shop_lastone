import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sandwich_shop/models/sandwich.dart';

typedef AssetLoader = Future<String> Function(String path);

/// Loads sandwich metadata from assets/sandwiches.json and caches it in memory.
class SandwichRepository {
  SandwichRepository._privateConstructor();
  static final SandwichRepository _instance =
      SandwichRepository._privateConstructor();
  factory SandwichRepository() => _instance;

  List<Sandwich>? _cache;

  /// Loads sandwiches from the JSON asset on first call and caches the result.
  ///
  /// [loader] may be provided for tests to inject in-memory JSON. If not
  /// provided, the repository will use [rootBundle.loadString].
  Future<List<Sandwich>> getAllSandwiches({AssetLoader? loader}) async {
    if (_cache != null) return _cache!;

    final load = loader ?? ((path) => rootBundle.loadString(path));
    final jsonString = await load('assets/sandwiches.json');
    final Map<String, dynamic> data =
        json.decode(jsonString) as Map<String, dynamic>;
    final List items = data['sandwiches'] as List? ?? [];

    _cache = items
        .map((e) => Sandwich.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cache!;
  }

  /// Returns a sandwich by id, or null if not found.
  Future<Sandwich?> getSandwichById(String id, {AssetLoader? loader}) async {
    final list = await getAllSandwiches(loader: loader);
    try {
      return list.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clears the in-memory cache. Next call to [getAllSandwiches] will reload the asset.
  void clearCache() {
    _cache = null;
  }
}
