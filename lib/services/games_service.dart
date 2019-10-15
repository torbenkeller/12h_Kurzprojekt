import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kurzprojekt/buisness_logic/game.dart';

enum Endpoint { games, genres, covers }

class GamesService {
  static const String API_KEY = 'ec34f09052b8317b6a56be2039b26193';
  static const String API_URL = 'https://api-v3.igdb.com/';
  static GamesService _gamesService;

  Map<int, String> _genreNames = <int, String>{};
  Map<int, Game> _gameCache = <int, Game>{};

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
    List<dynamic> jsonGames = jsonDecode(response.body.toString());
    for (Map<String, dynamic> game in jsonGames) {
      List<String> genres = <String>[];
      if (game['genres'] != null) {
        List<dynamic> jsonGenres = game['genres'].toList();
        for (int genreID in jsonGenres) {
          genres.add(await getGenreName(id: genreID));
        }
      }
      Game modelGame = Game.fromJson(game, genres);
      games.add(modelGame);
      _gameCache[modelGame.id] = modelGame;
    }
    return games;
  }

  Future<Map<String, dynamic>> getGameDetails({@required int id}) async {
    http.Response response = await postRequest(
        endpoint: Endpoint.games,
        query: 'fields storyline, summary, url, cover;'
            'where id = $id;');
    List<dynamic> jsonGames = jsonDecode(response.body.toString());
    for (Map<String, dynamic> game in jsonGames) {
      String coverURL = await getCoverURL(id: game['cover']);
      game['cover'] = coverURL;
      return game;
    }
    return null;
  }

  Future<Game> getGameById({@required int id}) async {
    if (_gameCache[id] != null) return _gameCache[id];
    http.Response response = await postRequest(
        endpoint: Endpoint.games,
        query: 'fields total_rating, name, genres;'
            'where id = $id;');
    List<dynamic> jsonGames = jsonDecode(response.body.toString());
    for (Map<String, dynamic> game in jsonGames) {
      List<String> genres = <String>[];
      if (game['genres'] != null) {
        List<dynamic> jsonGenres = game['genres'].toList();
        for (int genreID in jsonGenres) {
          genres.add(await getGenreName(id: genreID));
        }
      }
      Game modelGame = Game.fromJson(game, genres);
      _gameCache[modelGame.id] = modelGame;
      return modelGame;
    }
    return null;
  }

  Future<String> getGenreName({@required int id}) async {
    if (_genreNames[id] != null) return _genreNames[id];
    http.Response response = await postRequest(
        endpoint: Endpoint.genres, query: 'fields name; where id = $id;');
    List<dynamic> jsonGenre = jsonDecode(response.body);
    _genreNames[id] = jsonGenre[0]['name'];
    return jsonGenre[0]['name'];
  }

  Future<String> getCoverURL({@required int id}) async {
    http.Response response = await postRequest(
        endpoint: Endpoint.covers, query: 'fields url; where id = $id;');
    List<dynamic> results = jsonDecode(response.body);
    for (Map<String, dynamic> result in results) {
      return result['url'];
    }
    return null;
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
