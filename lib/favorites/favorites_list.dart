import 'package:flutter/material.dart';
import 'package:kurzprojekt/buisness_logic/favorite_entry.dart';
import 'package:kurzprojekt/buisness_logic/favorite_notifier.dart';
import 'package:kurzprojekt/buisness_logic/game.dart';
import 'package:kurzprojekt/services/cache_service.dart';
import 'package:kurzprojekt/services/games_service.dart';
import 'package:provider/provider.dart';

class FavoritesList extends StatefulWidget {
  final List<Game> games;
  final List<FavoriteEntry> entries;

  const FavoritesList({Key key, @required this.games, @required this.entries})
      : super(key: key);

  @override
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  ScrollController controller = ScrollController();
  bool loadNew = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() async {
      if (controller.position.pixels <=
              controller.position.maxScrollExtent - 400 &&
          !loadNew &&
          widget.games.length < widget.entries.length) {
        loadNew = true;
        Game newGames = await GamesService.getInstance()
            .getGameById(id: widget.entries[widget.games.length].gameID);
        setState(() {
          widget.games.add(newGames);
        });
        loadNew = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        CacheService cache = CacheService.getInstance();
        List<FavoriteEntry> entries =
            (await cache.loadFavorites()).values.toList();
        entries.sort((a, b) => a.lastChangedDate.millisecondsSinceEpoch
            .compareTo(b.lastChangedDate.millisecondsSinceEpoch));
        List<Game> games = <Game>[];
        for (int i = 0; i < 20 && i < entries.length; i++) {
          games.add(await GamesService.getInstance()
              .getGameById(id: entries[i].gameID));
        }
        setState(() {
          widget.games.clear();
          widget.games.addAll(games);
          widget.entries.clear();
          widget.entries.addAll(entries);
        });
      },
      child: ListView.builder(
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          if (index == widget.games.length)
            return Container(
              height: 60,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          return Consumer<FavoriteNotifier>(
              builder: (BuildContext context, FavoriteNotifier favorites, _) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  widget.games[index].totalRating.toInt().toString(),
                ),
                backgroundColor: Color.fromARGB(
                    255,
                    ((100 - widget.games[index].totalRating).abs() * 2.55)
                        .toInt(),
                    ((widget.games[index].totalRating).abs() * 2.55).toInt(),
                    0),
              ),
              title: Text(widget.games[index].name),
              subtitle: (widget.games[index].genres.length > 0)
                  ? Text(
                      widget.games[index].genres.reduce((a, b) => a + ', ' + b))
                  : null,
              trailing: IconButton(
                icon: Icon((favorites.entries[widget.games[index].id] != null)
                    ? Icons.star
                    : Icons.star_border),
                onPressed: () {
                  if (favorites.entries[widget.games[index].id] != null) {
                    favorites.remove(widget.games[index].id);
                  } else {
                    favorites.add(FavoriteEntry(
                        lastChangedDate: DateTime.now(),
                        gameID: widget.games[index].id));
                  }
                },
              ),
            );
          });
        },
        itemCount: widget.games.length +
            ((widget.games.length < widget.entries.length) ? 1 : 0),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
