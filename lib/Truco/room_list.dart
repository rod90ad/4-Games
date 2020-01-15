import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:four_games/Truco/room_list_tile.dart';
import 'package:four_games/Truco/room_model.dart';
import 'package:four_games/Truco/truco_room.dart';

class RoomList extends StatefulWidget {
  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection("truco_rooms").snapshots(includeMetadataChanges: false),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.documents.length>0){
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(3),
                  reverse: false,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, int index){
                    RoomModel model = RoomModel.fromMap(snapshot.data.documents[index].data, id: snapshot.data.documents[index].documentID);
                    return GestureDetector(
                      child: RoomListTile(model),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TrucoRoom(model)));
                      },
                    );
                  },
                ),
              );
            }else{
              return Expanded(child: Center(child: Text("No rooms")));
            }
          }else{
            return Expanded(child: Center(child: CircularProgressIndicator()));
          }
        },
      )
    );
  }
}