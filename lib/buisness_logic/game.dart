import 'package:flutter/cupertino.dart';
import 'package:kurzprojekt/services/games_service.dart';

class Game {
  int _id;
  String _name;
  double _totalRating;
  List<String> _genres;

  Game(
      {@required int id,
      @required String name,
      @required double totalRating,
      @required List<String> genres})
      : this._id = id,
        this._name = name,
        this._totalRating = totalRating,
        this._genres = genres;

  static Game fromJson(Map<String, dynamic> json, List<String> genres) => Game(
      id: json['id'] ?? -1,
      name: json['name'] ?? 'No name defined',
      totalRating: json['total_rating'] ?? -1,
      genres: genres ?? <String>[]);

  Future<void> getDetails() async {
    Map<String, dynamic> response =
        await GamesService.getInstance().getGameDetails(id: _id);
  }

  List<String> get genres => _genres;

  get id => this._id;

  double get totalRating => _totalRating;

  String get name => _name;

  @override
  String toString() {
    return '\nGame{_id: $_id, _name: $_name, _totalRating: $_totalRating, _genres: $_genres}';
  }
}
