class RoomModel {

  String key;
  String name;
  int numberOfPlayers;
  String owner;
  String player2;
  String player3;
  String player4;
  String mode;

  RoomModel.fromMap(Map map, {String id}):
    key = id,
    name = map["room_name"],
    numberOfPlayers = map["number_of_players"],
    owner = map["owner"],
    player2 = map["player2"],
    player3 = map["player3"],
    player4 = map["player4"],
    mode = map["mode"];

  Map<String, dynamic> toMap() => {
    "key": key,
    "room_name": name,
    "number_of_players": numberOfPlayers,
    "owner": owner,
    "player2": player2,
    "player3": player3,
    "player4": player4,
    "mode": mode,
  };
}