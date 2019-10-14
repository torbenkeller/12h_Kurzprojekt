import 'dart:convert';

import 'package:kurzprojekt/buisness_logic/favourite_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static CacheService _instance;
  static CacheService getInstance() {
    if (_instance != null) return _instance;
    _instance = CacheService();
    return _instance;
  }

  Future<Map<int, FavouriteEntry>> loadFavourites() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<int, FavouriteEntry> favourites = Map<int, FavouriteEntry>();
    String cachedData = sp.get('favourites');
    if (cachedData == null) return favourites;
    List<dynamic> jsonEntries = jsonDecode(cachedData).toList();
    for (Map<String, dynamic> entry in jsonEntries) {
      FavouriteEntry modelEntry = FavouriteEntry.fromJson(entry);
      favourites[modelEntry.gameID] = modelEntry;
    }
    return favourites;
  }

  Future<void> saveFavourites(List<FavouriteEntry> entries) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('favourites', jsonEncode(entries));
  }
}
