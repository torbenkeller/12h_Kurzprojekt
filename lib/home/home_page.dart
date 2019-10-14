import 'package:flutter/material.dart';
import 'package:kurzprojekt/buisness_logic/game.dart';
import 'package:kurzprojekt/services/games_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Game> games;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<Game> data = snapshot.data;
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) => ListTile(
              leading: CircleAvatar(
                child: Text(
                  data[index].totalRating.toInt().toString(),
                ),
                backgroundColor: Color.fromARGB(
                    255,
                    ((100 - data[index].totalRating).abs() * 2.55).toInt(),
                    ((data[index].totalRating).abs() * 2.55).toInt(),
                    0),
              ),
              title: Text(data[index].name),
              subtitle: (data[index].genres?.length > 0)
                  ? Text(data[index].genres.reduce((a, b) => a + ', ' + b))
                  : null,
            ),
            itemCount: data.length,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      future: GamesService.getInstance().getGames(start: 0, length: 20),
    );
  }
}
