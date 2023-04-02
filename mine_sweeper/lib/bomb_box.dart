import 'package:flutter/material.dart';


class BombBox extends StatelessWidget {

  final function;
  bool reveal;

  BombBox({super.key, required this.function,required this.reveal});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: reveal?Colors.grey[900]:Colors.grey,
        child: Center(child: Text(reveal?"X":'',style: TextStyle(color: Colors.white),),),
      ),
      onTap:function,
    );
  }
}
