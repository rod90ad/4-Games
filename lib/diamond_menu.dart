import 'package:diamond_menu/Diamonds/diamond_bottom.dart';
import 'package:diamond_menu/Diamonds/diamond_left.dart';
import 'package:diamond_menu/Diamonds/diamond_right.dart';
import 'package:diamond_menu/Diamonds/diamond_top.dart';
import 'package:flutter/material.dart';

class DiamondMenu extends StatefulWidget {
  @override
  DiamondMenuState createState() => DiamondMenuState();
}

class DiamondMenuState extends State<DiamondMenu> with TickerProviderStateMixin {
  
  AnimationController animTop;
  AnimationController animBottom;
  AnimationController animLeft;
  AnimationController animRight;

  DiamondTop dTop;
  DiamondBottom dBottom;
  DiamondLeft dLeft;
  DiamondRight dRight;
  List<Widget> stackOrder = List<Widget>();

  @override
  void initState() {
    animTop = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animTop.addListener((){
      if(stackOrder.last!=dTop){
        if(this.mounted){
          setState(() {
            stackOrder.clear();
            stackOrder.add(dBottom);
            stackOrder.add(dLeft);
            stackOrder.add(dRight);
            stackOrder.add(dTop);
          });
        }
      }
    });
    dTop = DiamondTop(animTop);

    animBottom = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animBottom.addListener((){
      if(stackOrder.last!=dBottom){
        if(this.mounted){
          setState(() {
            stackOrder.clear();
            stackOrder.add(dTop);
            stackOrder.add(dLeft);
            stackOrder.add(dRight);
            stackOrder.add(dBottom);
          });
        }
      }
    });
    dBottom = DiamondBottom(animBottom);

    animLeft = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animLeft.addListener((){
      if(stackOrder.last!=dLeft){
        if(this.mounted){
          setState(() {
            stackOrder.clear();
            stackOrder.add(dTop);
            stackOrder.add(dRight);
            stackOrder.add(dBottom);
            stackOrder.add(dLeft);
          });
        }
      }
    });
    dLeft = DiamondLeft(animLeft);

    animRight = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animRight.addListener((){
      if(stackOrder.last!=dRight){
        if(this.mounted){
          setState(() {
            stackOrder.clear();
            stackOrder.add(dTop);
            stackOrder.add(dBottom);
            stackOrder.add(dLeft);
            stackOrder.add(dRight);
          });
        }
      }
    });
    dRight = DiamondRight(animRight);

    stackOrder.clear();
    stackOrder.add(dTop);
    stackOrder.add(dLeft);
    stackOrder.add(dRight);
    stackOrder.add(dBottom);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: stackOrder,
      ),
    );
  }
}