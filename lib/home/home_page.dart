import 'package:flutter/material.dart';
import 'package:kurzprojekt/buisness_logic/game.dart';
import 'package:kurzprojekt/home/home_list.dart';
import 'package:kurzprojekt/services/games_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
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
            return HomeList(data: snapshot.data);

          default:
            return Center(
              child: Text('Du bist offline!'),
            );
        }
      },
      future: GamesService.getInstance().getGames(start: 0, length: 20),
    );
  }
}
