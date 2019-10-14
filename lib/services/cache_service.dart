import 'dart:convert';

import 'package:kurzprojekt/buisness_logic/favorite_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static CacheService _instance;
  static CacheService getInstance() {
    if (_instance != null) return _instance;
    _instance = CacheService();
    return _instance;
  }

  Future<Map<int, FavoriteEntry>> loadFavorites() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<int, FavoriteEntry> favorites = Map<int, FavoriteEntry>();
    String cachedData = sp.get('favorites');
    if (cachedData == null) return favorites;
    List<dynamic> jsonEntries = jsonDecode(cachedData).toList();
    for (Map<String, dynamic> entry in jsonEntries) {
      FavoriteEntry modelEntry = FavoriteEntry.fromJson(entry);
      favorites[modelEntry.gameID] = modelEntry;
    }
    return favorites;
  }

  Future<void> saveFavorites(List<FavoriteEntry> entries) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('favorites', jsonEncode(entries));
  }
}
