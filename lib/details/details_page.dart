import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kurzprojekt/buisness_logic/favorite_entry.dart';
import 'package:kurzprojekt/buisness_logic/favorite_notifier.dart';
import 'package:kurzprojekt/buisness_logic/game.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetailsPage extends StatelessWidget {
  final Game game;

  const GameDetailsPage({Key key, this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Game>(
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (!snapshot.hasData)
              return Scaffold(
                appBar: AppBar(
                  title: Text(game.name),
                ),
                body: Center(
                  child: Text('Du bist Offline!'),
                ),
              );
            Game data = snapshot.data;
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300.0,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(data.name),
                      background: (data.pictureURL != null)
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: data.pictureURL,
                            )
                          : null,
                    ),
                    actions: <Widget>[
                      CircleAvatar(
                        child: Text(data.totalRating.toInt().toString()),
                      ),
                      Consumer<FavoriteNotifier>(
                        builder: (_, FavoriteNotifier favorites, __) =>
                            IconButton(
                          icon: Icon((favorites.entries[data.id] != null)
                              ? Icons.star
                              : Icons.star_border),
                          onPressed: () {
                            if (favorites.entries[data.id] != null) {
                              favorites.remove(data.id);
                            } else {
                              favorites.add(FavoriteEntry(
                                  lastChangedDate: DateTime.now(),
                                  gameID: data.id));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              if (data.summary != null)
                                Text(
                                  'Inhalt',
                                  style: Theme.of(context).textTheme.title,
                                ),
                              if (data.summary != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(data.summary),
                                ),
                              if (data.story != null)
                                Text(
                                  'Story',
                                  style: Theme.of(context).textTheme.title,
                                ),
                              if (data.story != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(data.story),
                                ),
                              if (data.websiteURL != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: GestureDetector(
                                      onTap: () =>
                                          _launchWebsiteURL(data.websiteURL),
                                      child: Text(data.websiteURL,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor))),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

          default:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
      future: game.getDetails(),
    );
  }

  _launchWebsiteURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
