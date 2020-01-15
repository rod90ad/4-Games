import 'dart:math';
import 'package:flutter/material.dart';
import 'package:four_games/Diamonds/diamond_right.dart';
import 'package:four_games/Utils/sharedPreferences.dart';
import 'package:four_games/Utils/timer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'minesweeper_field.dart';
import 'minesweeper_model.dart';

class Minesweeper extends StatelessWidget {
  
  Minesweeper(this.parent);

  final DiamondRightState parent;
  
  List<List<MineSweeperModel>> field = List<List<MineSweeperModel>>();
  List<List<GlobalKey<MineSweeperFieldState>>> keys = new List<List<GlobalKey<MineSweeperFieldState>>>();
  GlobalKey<TimerState> timer = GlobalKey();
  GlobalKey<_MensagemState> mensagem = GlobalKey();
  GlobalKey<FlagsRemainingState> flagsRemaining = GlobalKey();

  final int numberOfRows = 18;
  final int numberOfColumns = 14;
  final int numberOfMines = 40;
  bool isGameOver = false;

  void newGame(){
    parent.refresh();
  }
  
  @override
  Widget build(BuildContext context) {
    _generateMines();
    _calculateNumberAround();
    _setColors();
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 4, right: 4, top: 6),
          color: Colors.green[800],
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
              Mensagem(mensagem),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.flag, color: Colors.red),
                    SizedBox(width: 3),
                    FlagsRemaining(flagsRemaining, numberOfMines),
                    SizedBox(width: 6),
                    Icon(MdiIcons.clock, color: Colors.yellow),
                    SizedBox(width: 3),
                    Timer(timer)
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: IconButton(
                  icon: Icon(MdiIcons.trophy, color: Colors.yellow),
                  onPressed: (){
                    showBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          child: FutureBuilder<List<Record>>(
                            future: MySharedPreferences().getMinesweeperRecords(),
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                if(snapshot.data.isNotEmpty){
                                  return Column(
                                    children: snapshot.data.map((record) => ListTile(leading: getPosition(record.position), title: Text("Win in ${record.record} seconds"), subtitle: getWinDate(record.date))).toList(),
                                  );
                                }else{
                                  return Column(
                                    children: <Widget>[
                                      ListTile(leading: Icon(MdiIcons.emoticonSad), title: Text("No leadboards yet"))
                                    ],
                                  );
                                }
                              }else{
                                return LinearProgressIndicator();
                              }
                            },
                          ),
                        );
                      }
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(MdiIcons.newBox, size: 30, color: Colors.white),
                onPressed: newGame,
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - (AppBar().preferredSize.height * 4),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 4, right: 4, bottom: 4),
          color: Colors.transparent,
          child: GridView.count(
            key: Key("gridView"),
            crossAxisCount: numberOfColumns,
            children: _getListOfWidgets(),
          ),
        )
      ],
    );
  }

  Widget getPosition(int pos){
    switch(pos){
      case 1: return Text("1st", style: TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold));
      case 2: return Text("2nd", style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold));
      case 3: return Text("3rd", style: TextStyle(color: Colors.brown, fontSize: 16, fontWeight: FontWeight.bold));
      case 4: return Text("4th", style: TextStyle(color: Colors.grey[300], fontSize: 15));
      case 5: return Text("5th", style: TextStyle(color: Colors.grey[300], fontSize: 15));
      case 6: return Text("6th", style: TextStyle(color: Colors.grey[300], fontSize: 15));
      case 7: return Text("7th", style: TextStyle(color: Colors.grey[300], fontSize: 15));
      case 8: return Text("8th", style: TextStyle(color: Colors.grey[300], fontSize: 15));
      case 9: return Text("9th", style: TextStyle(color: Colors.grey[300], fontSize: 15));
      case 10: return Text("10th", style: TextStyle(color: Colors.grey[300], fontSize: 15));
      default: return Text("");
    }
  }

  Widget getWinDate(String date){
    DateTime dt = DateTime.parse(date);
    return Text("in ${dt.day}/${dt.month}/${dt.year} - ${dt.hour}:${dt.minute}");
  }

  void gameOver()async{
    timer.currentState.stopTimer();
    mensagem.currentState.setMensagem("Game Over");
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
    timer.currentState.stopTimer();
    mensagem.currentState.setMensagem("Victory!!!");
    MySharedPreferences().setMinesweeperRecord(timer.currentState.timeInSeconds);
  }

  Future<void> _clickLeftTop(int r, int c) async { if(r-1>=0 && c-1>=0) await keys[r-1][c-1].currentState.onTap(); return; } //diagonal esquerda cima
  Future<void> _clickTop(int r, int c) async { if(r-1>=0) await keys[r-1][c].currentState.onTap(); return; } //cima
  Future<void> _clickRightTop(int r, int c) async { if(r-1>=0 && c+1<numberOfColumns) await keys[r-1][c+1].currentState.onTap(); return; } //diagonal direita cima
  Future<void> _clickLeft(int r, int c) async { if(c-1>=0) await keys[r][c-1].currentState.onTap(); return; } //esquerda
  Future<void> _clickRight(int r, int c) async { if(c+1<numberOfColumns) await keys[r][c+1].currentState.onTap(); return; } //direita
  Future<void> _clickLeftBottom(int r, int c) async { if(r+1<numberOfRows && c-1>=0) await keys[r+1][c-1].currentState.onTap(); return; } //diagonal esquerda baixo
  Future<void> _clickBottom(int r, int c) async { if(r+1<numberOfRows) await keys[r+1][c].currentState.onTap(); return; } //baixo
  Future<void> _clickRightBottom(int r, int c) async { if(r+1<numberOfRows && c+1<numberOfColumns) await keys[r+1][c+1].currentState.onTap(); return; } //diagonal direita baixo

  Future<void> clickAround(int r, int c) async {
    await _clickLeftTop(r, c);
    await _clickTop(r, c);
    await _clickRightTop(r, c);
    await _clickLeft(r, c);
    await _clickRight(r, c);
    await _clickLeftBottom(r, c);
    await _clickBottom(r, c);
    await _clickRightBottom(r, c);
    return;
  }

  List<Widget> _getListOfWidgets(){
    List<Widget> listOfWidgets = new List<Widget>();
    for(int i=0; i< numberOfRows; i++){
      for(int j=0;j<numberOfColumns; j++){
        listOfWidgets.add(MineSweeperField(field[i][j], this, keys[i][j], timer, flagsRemaining));
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

class Mensagem extends StatefulWidget {
  
  Mensagem(Key key): super(key: key);
  
  @override
  _MensagemState createState() => _MensagemState();
}

class _MensagemState extends State<Mensagem> {
  
  String mensagem = "";

  void setMensagem(String mensagem){
    setState(() {
      this.mensagem = mensagem;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.28,
      child: Text(mensagem, style: TextStyle(color: Colors.white, fontSize: 22)),
    );
  }
}

class FlagsRemaining extends StatefulWidget {
  
  FlagsRemaining(Key key, this.flagsRemaining): super(key: key);

  final int flagsRemaining;

  @override
  FlagsRemainingState createState() => FlagsRemainingState();
}

class FlagsRemainingState extends State<FlagsRemaining> {
  
  int flags;

  void increment(){
    setState(() {
      flags++;
    });
  }

  void decrement(){
    setState(() {
      flags--;
    });
  }

  @override
  void initState() {
    flags = this.widget.flagsRemaining;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text("${this.widget.flagsRemaining}", style: TextStyle(color: Colors.white, fontSize: 22));
  }
}