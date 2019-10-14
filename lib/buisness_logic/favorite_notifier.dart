import 'package:flutter/foundation.dart';
import 'package:kurzprojekt/buisness_logic/favorite_entry.dart';
import 'package:kurzprojekt/services/cache_service.dart';

class FavoriteNotifier with ChangeNotifier {
  Map<int, FavoriteEntry> _entries = Map<int, FavoriteEntry>();

  FavoriteNotifier(Map<int, FavoriteEntry> data) {
    _entries.addAll(data);
  }

  Map<int, FavoriteEntry> get entries => Map.unmodifiable(_entries);

  void add(FavoriteEntry data) {
    _entries[data.gameID] = data;
    CacheService.getInstance().saveFavorites(List.from(_entries.values));
    notifyListeners();
  }

  void remove(int id) {
    _entries.remove(id);
    CacheService.getInstance().saveFavorites(List.from(_entries.values));
    notifyListeners();
  }
}
