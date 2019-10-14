import 'package:flutter/material.dart';
import 'package:kurzprojekt/buisness_logic/game.dart';
import 'package:kurzprojekt/services/games_service.dart';

class HomeList extends StatefulWidget {
  final List<Game> data;

  const HomeList({Key key, this.data}) : super(key: key);

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        List<Game> newGames =
            await GamesService.getInstance().getGames(start: 0, length: 20);
        setState(() {
          widget.data.clear();
          widget.data.addAll(newGames);
        });
      },
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => ListTile(
          onTap: () => setState(() {}),
          leading: CircleAvatar(
            child: Text(
              widget.data[index].totalRating.toInt().toString(),
            ),
            backgroundColor: Color.fromARGB(
                255,
                ((100 - widget.data[index].totalRating).abs() * 2.55).toInt(),
                ((widget.data[index].totalRating).abs() * 2.55).toInt(),
                0),
          ),
          title: Text(widget.data[index].name),
          subtitle: (widget.data[index].genres.length > 0)
              ? Text(widget.data[index].genres.reduce((a, b) => a + ', ' + b))
              : null,
        ),
        itemCount: widget.data.length,
      ),
    );
  }
}
