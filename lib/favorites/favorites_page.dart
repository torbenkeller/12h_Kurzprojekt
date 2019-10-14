import 'package:flutter/material.dart';
import 'package:kurzprojekt/buisness_logic/favorite_entry.dart';
import 'package:kurzprojekt/buisness_logic/game.dart';
import 'package:kurzprojekt/favorites/favorites_list.dart';
import 'package:kurzprojekt/services/cache_service.dart';
import 'package:kurzprojekt/services/games_service.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (!snapshot.hasData)
              return Center(
                child: Text('Du bist offline!'),
              );
            List<Game> games = snapshot.data['games'];
            List<FavoriteEntry> entries = snapshot.data['entries'];
            return FavoritesList(games: games, entries: entries);

          default:
            return Center(
              child: Text('Du bist offline!'),
            );
        }
      },
      future: _getGames(),
    );
  }

  Future<Map<String, dynamic>> _getGames() async {
    CacheService cache = CacheService.getInstance();
    List<FavoriteEntry> entries = (await cache.loadFavorites()).values.toList();
    entries.sort((a, b) => a.lastChangedDate.millisecondsSinceEpoch
        .compareTo(b.lastChangedDate.millisecondsSinceEpoch));
    List<Game> games = <Game>[];
    for (int i = 0; i < 20 && i < entries.length; i++) {
      games.add(
          await GamesService.getInstance().getGameById(id: entries[i].gameID));
    }
    return {'games': games, 'entries': entries};
  }
}
