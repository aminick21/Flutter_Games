import 'package:flutter/material.dart';


class MyBox extends StatelessWidget {

  final child;
  final function;
  bool reveal;

   MyBox({super.key, required this.function, required this.child,required this.reveal});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: reveal?Colors.grey[100]:Colors.grey,
        child: Center(
            child: Text(reveal?(child.toString()=='0'?'':child.toString()):'',
            style: TextStyle(
              color: child==1?Colors.blue:child==2?Colors.green:Colors.red,
            ),)),
      ),
      onTap:function,
    );
  }
}
