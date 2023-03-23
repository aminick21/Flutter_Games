import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
Color tileColor;
Tile({required this.tileColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: tileColor,

        ),

      ),
    );
  }
}
