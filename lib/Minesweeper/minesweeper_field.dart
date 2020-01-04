import 'package:diamond_menu/Minesweeper/minesweeper_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'minesweeper.dart';

class MineSweeperField extends StatefulWidget {
  
  MineSweeperField(this.model, this.reference, Key key): super(key:key);

  final MineSweeperModel model;
  final Minesweeper reference;
  
  @override
  MineSweeperFieldState createState() => MineSweeperFieldState();
}

class MineSweeperFieldState extends State<MineSweeperField> {
  
  Color myColor;
  
  Future<void> onTap() async {
    if(!widget.model.flag){
      if(widget.model.bomb){
        widget.model.iconToShow = Icon(MdiIcons.bomb, color: Colors.red);
        if(!widget.reference.isGameOver){
          widget.reference.isGameOver=true;
          widget.reference.gameOver();
        }
        setState(() {});
      }else{
        if(!widget.model.clicked && !widget.reference.isGameOver){
          myColor = widget.model.color==Colors.green[600] ? Colors.brown[300] : Colors.brown[200];
          widget.model.iconToShow = Center(
            child: Text(widget.model.getNumberAround(), style: TextStyle(color: _getColorOfNumber(widget.model.numberAround), fontSize: 20, fontWeight: FontWeight.bold)),
          );
          if(widget.model.getNumberAround().isEmpty){
            widget.reference.clickAround(widget.model.numberOfRow, widget.model.numberOfColumn);
          }
          widget.model.clicked = true;
          widget.reference.verifyVictory();
          if(this.mounted)
            setState((){});
        }
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    if(myColor==null)
      myColor = widget.model.color;
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(0.2),
        color: myColor,
        child: widget.model.iconToShow,
      ),
      onTap: onTap,
      onLongPress: (){
          if(!widget.model.flag && !widget.model.clicked){
            setState(() { widget.model.iconToShow = Icon(Icons.flag, color: Colors.red); });
          }else if(!widget.model.clicked){
            setState(() { widget.model.iconToShow = Container(); });
          }
          widget.model.flag = !widget.model.flag;
        },
    );
  }

  Color _getColorOfNumber(int numberAround){
    switch(numberAround){
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple[800];
      case 5:
        return Colors.red[800];
      case 6:
        return Colors.black;
      default:
        return Colors.black;
    }
  }
}