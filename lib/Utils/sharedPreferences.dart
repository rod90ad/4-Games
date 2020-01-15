import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {

  final String minesweeperKey = "minesweeper";

  void setMinesweeperRecord(int time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Record newRecord = Record.fromMap({"date":DateTime.now().toString(), "record":time});
    List<dynamic> stringList = prefs.containsKey(minesweeperKey) ? json.decode(prefs.getString(minesweeperKey)) : List<String>();
    List<Record> top10 = stringList.isNotEmpty ? stringList.map((record) => Record.fromMap(json.decode(record))).toList() : List<Record>();
    if(top10.isNotEmpty){
      top10.add(newRecord);
      top10.sort((r1, r2) => r1.record.compareTo(r2.record));
      while (top10.length>10) {
        top10.removeLast();
      }
      for(int i=0;i<top10.length;i++){
        top10[i].position = i+1;
      }
    }else{
      top10.add(newRecord);
      for(int i=0;i<top10.length;i++){
        top10[i].position = i+1;
      }
    }
    stringList = top10.map((record) => json.encode(record.toMap())).toList();
    await prefs.setString(minesweeperKey, json.encode(stringList));
  }

  Future<List<Record>> getMinesweeperRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> stringList = prefs.containsKey(minesweeperKey) ? json.decode(prefs.getString(minesweeperKey)) : List<String>();
    List<Record> top10 = stringList.isNotEmpty ? stringList.map((record) => Record.fromMap(json.decode(record))).toList() : List<Record>();
    return top10;
  }
}

class Record {

  String date;
  int record;
  int position;

  Record.fromMap(Map<String, dynamic> map):
    date = map["date"],
    record = map["record"],
    position = map["position"];

  Map<String, dynamic> toMap() => {
    "date" : date,
    "record" : record,
    "position" : position
  };

}