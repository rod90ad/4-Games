import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  
  Timer(Key key): super(key: key);
  
  @override
  TimerState createState() => TimerState();
}

class TimerState extends State<Timer> with SingleTickerProviderStateMixin {
  
  int timeInSeconds = 0;
  bool running = false;
  
  @override
  void initState() {
    super.initState();
    timing();
  }

  void startTimer() {
    setState(() {
      running = true;
    });
  }

  void timing() async {
    await Future.delayed(Duration(seconds: 1));
    if(running){
      setState(() {
        timeInSeconds++;
      });
    }
    timing();
  }

  void resetTimer(){
    setState(() {
      timeInSeconds = 0;
    });
  }

  void stopTimer(){
    setState(() {
      running=false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text("$timeInSeconds", style: TextStyle(color: Colors.white, fontSize: 22));
  }
}