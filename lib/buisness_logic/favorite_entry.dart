import 'package:flutter/cupertino.dart';

class FavoriteEntry {
  DateTime _lastChangedDate;
  int _gameID;
  FavoriteEntry({@required DateTime lastChangedDate, @required int gameID})
      : this._lastChangedDate = lastChangedDate,
        this._gameID = gameID;

  static FavoriteEntry fromJson(Map<String, dynamic> json) => FavoriteEntry(
      gameID: json['gameID'],
      lastChangedDate: DateTime.parse(json['lastChangedDate']));

  Map<String, dynamic> toJson() => <String, dynamic>{
        'gameID': _gameID,
        'lastChangedDate': _lastChangedDate.toIso8601String()
      };

  DateTime get lastChangedDate => _lastChangedDate;

  int get gameID => _gameID;

  @override
  int get hashCode {
    return _gameID.hashCode;
  }

  @override
  bool operator ==(other) {
    return _gameID == other?.gameID;
  }
}
