import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:four_games/Truco/room_model.dart';
import 'package:four_games/Truco/truco.dart';
import 'package:four_games/Utils/block_open.dart';

class DiamondBottom extends StatefulWidget {
  
  final AnimationController animationController;

  DiamondBottom(this.animationController);

  @override
  DiamondBottomState createState() => DiamondBottomState();
}

class DiamondBottomState extends State<DiamondBottom> {
  
  Animation offset;
  Animation rotation;
  Animation backgroundColor;

  @override
  void initState() {
    offset = Tween<double>(begin: 0.211, end: 0.0).animate(widget.animationController);
    rotation = Tween<double>(begin: 45.0, end: 0.0).animate(widget.animationController);
    backgroundColor = ColorTween(begin: Colors.red, end: Colors.red[200]).animate(widget.animationController);
    widget.animationController.addListener((){
      if(this.mounted)
        setState((){});
    });
    super.initState();
  }

  void turnToWindow(){
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
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform.translate(
      offset: Offset(0.0, size.width * offset.value),
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
                                Text("Truco", style: TextStyle(color: Colors.white, fontSize: 10)),
                                SizedBox(
                                  child: Image.asset("images/truco.png", fit: BoxFit.fill),
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
                        title: Text("Truco", style: TextStyle(color: Colors.red)), 
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.red),
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
                                  return Truco(this);
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
              ),
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