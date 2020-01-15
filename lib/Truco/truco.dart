import 'package:flutter/material.dart';
import 'package:four_games/Diamonds/diamond_bottom.dart';
import 'package:four_games/Truco/room_list.dart';

class Truco extends StatelessWidget {
  
  Truco(this.parent);

  final DiamondBottomState parent;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: parent.widget.animationController.value==1.0 ? RoomList() : Container(),
    );
  }
}