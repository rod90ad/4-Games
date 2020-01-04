import 'package:flutter/material.dart';

class MineSweeperModel {

  bool bomb;
  int numberOfRow;
  int numberOfColumn;
  int numberAround;
  Color color;
  Widget iconToShow;
  bool flag = false;
  bool clicked = false;

  String getNumberAround(){
    if(numberAround==0)
      return "";
    else
      return "$numberAround";
  }

  MineSweeperModel({this.bomb, this.numberAround, this.numberOfRow, this.numberOfColumn, this.color, this.iconToShow});
}