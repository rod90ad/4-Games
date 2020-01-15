import 'package:flutter/material.dart';
import 'package:four_games/Truco/room_model.dart';

class RoomListTile extends StatelessWidget {
  
  RoomListTile(this.model);

  final RoomModel model;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      margin: EdgeInsets.only(top: 3, left: 3, right: 3, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        boxShadow: [BoxShadow(color: Colors.black)]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(model.name ?? "Undefined")
        ],
      ),
    );
  }
}