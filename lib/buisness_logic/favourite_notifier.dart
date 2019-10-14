import 'package:flutter/foundation.dart';
import 'package:kurzprojekt/buisness_logic/favourite_entry.dart';
import 'package:kurzprojekt/services/cache_service.dart';

class FavouriteNotifier with ChangeNotifier {
  Map<int, FavouriteEntry> _entries = Map<int, FavouriteEntry>();

  FavouriteNotifier(Map<int, FavouriteEntry> data) {
    _entries.addAll(data);
  }

  get entries => Map.unmodifiable(_entries);

  void add(FavouriteEntry data) {
    _entries[data.gameID] = data;
    CacheService.getInstance().saveFavourites(List.from(_entries.values));
    notifyListeners();
  }

  void remove(int id) {
    _entries.remove(id);
    CacheService.getInstance().saveFavourites(List.from(_entries.values));
    notifyListeners();
  }
}
