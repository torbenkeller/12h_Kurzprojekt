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
  ScrollController controller = ScrollController();
  bool loadNew = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() async {
      if (controller.position.pixels <=
              controller.position.maxScrollExtent - 400 &&
          !loadNew &&
          widget.data.length < 150) {
        loadNew = true;
        List<Game> newGames = await GamesService.getInstance()
            .getGames(start: widget.data.length, length: 10);
        setState(() {
          widget.data.addAll(newGames);
        });
        loadNew = false;
      }
    });
  }

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
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          if (index == widget.data.length)
            return Container(
              height: 60,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          return ListTile(
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
          );
        },
        itemCount: widget.data.length + ((widget.data.length < 150) ? 1 : 0),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
