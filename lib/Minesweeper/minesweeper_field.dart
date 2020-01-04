import 'package:diamond_menu/Minesweeper/minesweeper_model.dart';
import 'package:flutter/material.dart';

class MineSweeperField extends StatefulWidget {
  
  final MineSweeperModel model;

  MineSweeperField(this.model);

  @override
  _MineSweeperFieldState createState() => _MineSweeperFieldState();
}

class _MineSweeperFieldState extends State<MineSweeperField> {
  
  Widget iconToShow = Container();
  Color myColor;

  @override
  Widget build(BuildContext context) {
    if(myColor==null)
      myColor = widget.model.color;
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(0.2),
        color: myColor,
        child: iconToShow,
      ),
      onTap: (){
        print("Row: ${widget.model.numberOfRow} Column: ${widget.model.numberOfColumn}");
        if(widget.model.bomb){
          setState(() {
            iconToShow = Icon(Icons.flag, color: Colors.red);
          });
        }else{
          setState(() {
            myColor = widget.model.color==Colors.green[500] ? Colors.brown[300] : Colors.brown[200];
            iconToShow = Center(
              child: Text(widget.model.getNumberAround(), style: TextStyle(color: _getColorOfNumber(), fontSize: 20, fontWeight: FontWeight.bold)),
            );
          });
        }
      },
      onLongPress: (){
        setState(() {
          iconToShow = Icon(Icons.flag, color: Colors.red);
        });
      },
    );
  }

  Color _getColorOfNumber(){
    switch(widget.model.numberAround){
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