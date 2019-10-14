import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kurzprojekt/buisness_logic/game.dart';

enum Endpoint {
  games,
  genres,
}

class GamesService {
  static const String API_KEY = 'ec34f09052b8317b6a56be2039b26193';
  static const String API_URL = 'https://api-v3.igdb.com/';
  static GamesService _gamesService;

  Map<int, String> _genreNames = <int, String>{};

  static GamesService getInstance() {
    if (_gamesService != null) return _gamesService;
    _gamesService = new GamesService();
    return _gamesService;
  }

  Future<http.Response> postRequest({
    @required Endpoint endpoint,
    @required String query,
  }) async {
    http.Response response = await http.post(
      API_URL + EnumToString.parse(endpoint),
      headers: {'user-key': API_KEY},
      body: query,
    );
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<List<Game>> getGames(
      {@required int start, @required int length}) async {
    http.Response response = await postRequest(
      endpoint: Endpoint.games,
      query: 'fields total_rating, name, genres;'
          ' sort total_rating desc;'
          ' where total_rating > 1;'
          ' limit $length;'
          ' offset $start;',
    );
    List<Game> games = <Game>[];
//    String a =
//        '[{"id": 13271,"genres":[5,33],"name": "3D Starstrike","total_rating": 100.0},{"id": 23230,"name": "Playworld Superheroes","total_rating": 100.0},{"id": 5024,"genres": [8],"name": "The Munchables","total_rating": 100.0},{"id": 23746,"genres": [12],"name": "EverQuest: Evolution","total_rating": 100.0},{"id": 23809,"genres": [10],"name": "Motor City Online","total_rating": 100.0},{"id": 1458,"genres": [31],"name": "Ōkamiden","total_rating": 100.0},{"id": 9150,"genres": [4,14],"name": "Punch-Out!!","total_rating": 100.0},{"id": 23227,"name": "After Burner II 3D","total_rating": 100.0},{"id": 21639,"name": "Challenge Me: Math Workout","total_rating": 100.0},{"id": 23754,"name": "Tony Hawk\u0027s Pro Skater 4 Street","total_rating": 100.0},{"id": 23743,"genres": [31],"name": "Journey to Wild Divine","total_rating": 100.0},{"id": 804,"genres": [10,13,14],"name": "NASCAR Racing 2003 Season","total_rating": 100.0},{"id": 20921,"name": "Interwebs Troll Simulator","total_rating": 100.0},{"id": 657,"genres": [12],"name": "Dark Age of Camelot","total_rating": 100.0},{"id": 712,"genres": [13],"name": "Microsoft Flight Simulator 2004: A Century of Flight","total_rating": 100.0},{"id": 9186,"genres": [5],"name": "Robotron X","total_rating": 100.0},{"id": 24250,"genres": [11,13,15],"name": "SuperPower 2","total_rating": 100.0},{"id": 20860,"genres": [5,12],"name": "Destiny Legendary Edition","total_rating": 100.0},{"id": 21896,"name": "GTDUPEA V Remastered","total_rating": 100.0},{"id": 10250,"genres": [9],"name": "Droplitz","total_rating": 100.0}]';
    List<dynamic> jsonGames = jsonDecode(response.body.toString());
//    List<dynamic> jsonGames = jsonDecode(a);
    for (Map<String, dynamic> game in jsonGames) {
      List<String> genres = <String>[];
      if (game['genres'] != null) {
        List<dynamic> jsonGenres = game['genres'].toList();
        for (int genreID in jsonGenres) {
          genres.add(await getGenreName(id: genreID));
        }
      }
      games.add(Game.fromJson(game, genres));
    }
    return games;
  }

  Future<Map<String, dynamic>> getGameDetails({@required int id}) async {}

  Future<String> getGenreName({@required int id}) async {
    if (_genreNames[id] != null) return _genreNames[id];
    http.Response response = await postRequest(
        endpoint: Endpoint.genres, query: 'fields name; where id = $id;');
    List<dynamic> jsonGenre = jsonDecode(response.body);
    _genreNames[id] = jsonGenre[0]['name'];
    return jsonGenre[0]['name'];
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}
