import 'dart:async';
import 'package:flutter/material.dart';
import 'package:four_games/Minesweeper/minesweeper.dart';
import 'package:four_games/Utils/block_open.dart';

class DiamondRight extends StatefulWidget {
  
  final AnimationController animationController;

  DiamondRight(this.animationController);
  
  @override
  DiamondRightState createState() => DiamondRightState();
}

class DiamondRightState extends State<DiamondRight> {
  
  Animation offset;
  Animation rotation;
  Animation backgroundColor;
  bool novoJogo = false;

  @override
  void initState() {
    offset = Tween<double>(begin: 0.211, end: 0.0).animate(widget.animationController);
    rotation = Tween<double>(begin: 45.0, end: 0.0).animate(widget.animationController);
    backgroundColor = ColorTween(begin: Colors.green, end: Colors.green[200]).animate(widget.animationController);
    widget.animationController.addListener((){
      if(this.mounted)
        setState((){});
    });
    super.initState();
  }

  void turnToWindow(){
    novoJogo=false;
    if(widget.animationController.value == 0.0){
      BlockOpen.getInstance().setBlocked(true);
      widget.animationController.forward();
    }else if(widget.animationController.value == 1.0){
      widget.animationController.reverse();
      BlockOpen.getInstance().setBlocked(false);
    }
  }

  Future<bool> _renderTime() async {
    await Future.delayed(Duration(milliseconds: 300));
    return true;
  }

  void refresh(){
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform.translate(
      offset: Offset(size.width * offset.value, 0.0),
      child: RotationTransition(
        turns: AlwaysStoppedAnimation(rotation.value/360),
        child: GestureDetector(
            child:  Container(
            width: Tween<double>(begin: size.width * 0.3, end: size.width).animate(widget.animationController).value,
            height: Tween<double>(begin: size.width * 0.3, end: size.height).animate(widget.animationController).value,
            child: Scaffold(
              body: Stack(
                children: <Widget>[
                  Container(color: backgroundColor.value),
                  Opacity(
                    opacity: 1 - widget.animationController.value,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation((rotation.value * -1)/360),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: size.width * 0.2,
                            height: size.width * 0.2,
                            child: Column(
                              children: <Widget>[
                                Text("Minesweeper", style: TextStyle(color: Colors.white, fontSize: 10)),
                                SizedBox(
                                  child: Image.asset("images/minesweeper.png", fit: BoxFit.fill),
                                  width: size.width * 0.16,
                                  height: size.width * 0.16,
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: widget.animationController.value,
                    child: Scaffold(
                      backgroundColor: backgroundColor.value,
                      appBar: AppBar(
                        title: Text("Minesweeper", style: TextStyle(color: Colors.green)), 
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.green),
                          onPressed: () { 
                            if(widget.animationController.value==1.0)
                              turnToWindow();
                          },
                        ),
                      ),
                      body: Column(
                        children: <Widget>[
                          FutureBuilder<bool>(
                            future: _renderTime(),
                            builder: (context, snapshot){
                              if(snapshot.connectionState != ConnectionState.waiting){
                                if(snapshot.data){
                                  return Minesweeper(this);
                                }else{
                                  return Expanded(
                                    child:Center(child: CircularProgressIndicator())
                                  );
                                }
                              }else{
                                return Expanded(
                                  child:Center(child: CircularProgressIndicator())
                                );
                              }
                            },
                          )
                        ],
                      )
                    ),
                  ),
                ],
              )
            ),
          ),
          onTap: (){
            if(widget.animationController.value==0.0 && !BlockOpen.getInstance().isBlocked())
              turnToWindow();
          },
        ),
      ),
    );
  }
}