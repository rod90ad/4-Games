import 'dart:math';
import 'package:diamond_menu/Minesweeper/minesweeper_field.dart';
import 'package:diamond_menu/Minesweeper/minesweeper_model.dart';
import 'package:flutter/material.dart';

class Minesweeper extends StatelessWidget {
  
  List<List<MineSweeperModel>> field = List<List<MineSweeperModel>>();
  List<List<GlobalKey<MineSweeperFieldState>>> keys = new List<List<GlobalKey<MineSweeperFieldState>>>();
  final int numberOfRows = 18;
  final int numberOfColumns = 14;
  final int numberOfMines = 40;
  bool isGameOver = false;
  
  @override
  Widget build(BuildContext context) {
    _generateMines();
    _calculateNumberAround();
    _setColors();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(left: 4, top: 100, right: 4, bottom: 4),
      child: GridView.count(
        key: Key("gridView"),
        crossAxisCount: numberOfColumns,
        childAspectRatio: 1.0,
        padding: EdgeInsets.all(4),
        children: _getListOfWidgets(),
      ),
    );
  }

  void gameOver()async{
    for(int i=0;i<numberOfRows;i++){
      for(int j=0;j<numberOfColumns;j++){
        if(field[i][j].bomb) await keys[i][j].currentState.onTap();
      }
    }
  }

  void verifyVictory(){
    for(int i=0;i<numberOfRows;i++){
      for(int j=0;j<numberOfColumns;j++){
        if(!field[i][j].bomb)
          if(!field[i][j].clicked)
            return;
      }
    }
    print("Victory!!!");
  }

  void clickAround(int r, int c) async {
    if(r-1>=0 && c-1>=0) await keys[r-1][c-1].currentState.onTap();  //diagonal esquerda cima
    if(r-1>=0) await keys[r-1][c].currentState.onTap(); //cima
    if(r-1>=0 && c+1<numberOfColumns) await keys[r-1][c+1].currentState.onTap(); //diagonal direita cima
    if(c-1>=0) await keys[r][c-1].currentState.onTap(); //esquerda
    if(c+1<numberOfColumns) await keys[r][c+1].currentState.onTap(); //direita
    if(r+1<numberOfRows && c-1>=0) await keys[r+1][c-1].currentState.onTap(); //diagonal esquerda baixo
    if(r+1<numberOfRows) await keys[r+1][c].currentState.onTap(); //baixo
    if(r+1<numberOfRows && c+1<numberOfColumns) await keys[r+1][c+1].currentState.onTap(); //diagonal direita baixo
  }

  List<Widget> _getListOfWidgets(){
    List<Widget> listOfWidgets = new List<Widget>();
    for(int i=0; i< numberOfRows; i++){
      for(int j=0;j<numberOfColumns; j++){
        listOfWidgets.add(MineSweeperField(field[i][j], this, keys[i][j]));
      }
    }
    return listOfWidgets;
  }

  void _setColors(){
    Color color = Colors.green[500];
    for(int i=0; i < numberOfRows; i++){
      if(color==Colors.green[500])
        color=Colors.green[600];
      else
        color=Colors.green[500];
      for(int j=0;j<numberOfColumns; j++){
        if(color==Colors.green[500])
          color=Colors.green[600];
        else
          color=Colors.green[500];
        field[i][j].color = color;
      }
    }
  }

  void _calculateNumberAround(){
    for(int r=0;r<numberOfRows;r++){
      for(int c=0;c<numberOfColumns;c++){
        if(field[r][c].bomb){
          field[r][c].numberAround=-1;
        }else{
          int around = 0;
          if((r-1>=0 && c-1>=0) && field[r-1][c-1].bomb) around++;  //diagonal esquerda cima
          if((r-1>=0) && field[r-1][c].bomb) around++; //cima
          if((r-1>=0 && c+1<numberOfColumns) && field[r-1][c+1].bomb) around++; //diagonal direita cima
          if((c-1>=0) && field[r][c-1].bomb) around++; //esquerda
          if(c+1<numberOfColumns && field[r][c+1].bomb) around++; //direita
          if((r+1<numberOfRows && c-1>=0) && field[r+1][c-1].bomb) around++; //diagonal esquerda baixo
          if((r+1<numberOfRows) && field[r+1][c].bomb) around++; //baixo
          if((r+1<numberOfRows && c+1<numberOfColumns) && field[r+1][c+1].bomb) around++; //diagonal direita baixo
          field[r][c].numberAround = around;
        }
      }
    }
  }

  void _generateMines(){
    field.clear();
    for(int i=0;i<numberOfRows;i++){
      keys.add(List<GlobalKey<MineSweeperFieldState>>());
      field.add(List<MineSweeperModel>());
      for(int j=0;j<numberOfColumns;j++){
        keys[i].add(GlobalKey<MineSweeperFieldState>());
        field[i].add(MineSweeperModel(bomb: false, numberOfRow: i, numberOfColumn: j));
      }
    }
    for(int i=0; i< numberOfMines; i++){
      int row = Random().nextInt(numberOfRows);
      int column = Random().nextInt(numberOfColumns);
      if(!field[row][column].bomb)
        field[row][column].bomb=true;
      else
        i--;
    }
  }  
}