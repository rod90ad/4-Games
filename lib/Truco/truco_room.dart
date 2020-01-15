import 'package:flutter/material.dart';
import 'package:four_games/Truco/room_model.dart';

class TrucoRoom extends StatefulWidget {
  
  TrucoRoom(this.room);

  final RoomModel room;
  
  @override
  _TrucoRoomState createState() => _TrucoRoomState();
}

class _TrucoRoomState extends State<TrucoRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.room.name ?? "Undefined", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }
}