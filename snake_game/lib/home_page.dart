import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


enum SnakeDirection{LEFT,RIGHT,UP,DOWN}

class _HomeScreenState extends State<HomeScreen> {
  int rowSize = 10;
  int totalNumberOfCubes = 100;

  int score = 0;

  bool gameHasStarted=false;

  List<int> snakePos=[0,1,2];

  int foodPos=50;
  var currentDirection=SnakeDirection.RIGHT;


  void startGame(){
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        gameHasStarted=true;
        moveSnake();
        if(gameOver()){
          timer.cancel();
          showDialog(context: context, builder: (context)
          {return AlertDialog(
            title: Text("Game Over!!"),
          );
          }).then((value) => newGame());

        }
      });

    });
  }



  void moveSnake(){
    switch(currentDirection){
      case SnakeDirection.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          }
          else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;

      case SnakeDirection.RIGHT:
        {
          if(snakePos.last%rowSize==9){
            snakePos.add(snakePos.last+1-rowSize);
          }
          else{
            snakePos.add(snakePos.last+1);
          }
        }
        break;
      case SnakeDirection.UP:
        {
          if(snakePos.last<rowSize){
            snakePos.add(snakePos.last-rowSize+totalNumberOfCubes);
          }
          else{
            snakePos.add(snakePos.last-rowSize);
          }
        }
        break;
      case SnakeDirection.DOWN:
        {
          if(snakePos.last+rowSize>=totalNumberOfCubes){
            snakePos.add(snakePos.last+rowSize-totalNumberOfCubes);
          }
          else{
            snakePos.add(snakePos.last+rowSize);
          }

        }
        break;
        default:
    }

    if(snakePos.last==foodPos){
      eatFood();
    }
    else{
      snakePos.removeAt(0);
    }
  }


  void eatFood(){
    score++;
    while(snakePos.contains(foodPos)){
      foodPos=Random().nextInt(totalNumberOfCubes);
    }
  }

  bool gameOver(){
    List<int> snakeBody=snakePos.sublist(0,snakePos.length-1);

    if(snakeBody.contains(snakePos.last)){
      return true;
    }
    else {
      return false;
    }
 }

  void newGame(){
    setState(() {
      snakePos=[0,1,2];
      foodPos=55;
      score=0;
      currentDirection=SnakeDirection.RIGHT;
      gameHasStarted=false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //score
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  score.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Your Score : ",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          //grid
          Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details){
                  if(details.delta.dy>0 && currentDirection!=SnakeDirection.UP){
                    currentDirection=SnakeDirection.DOWN;
                  }
                  if(details.delta.dy<0 && currentDirection!=SnakeDirection.DOWN){
                    currentDirection=SnakeDirection.UP;
                  }
                },
                onHorizontalDragUpdate: (details){
                  if(details.delta.dx>0 && currentDirection!=SnakeDirection.LEFT){
                    currentDirection=SnakeDirection.RIGHT;
                  }
                  if(details.delta.dx<0 && currentDirection!=SnakeDirection.RIGHT){
                    currentDirection=SnakeDirection.LEFT;
                  }
                },
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowSize),
                    itemCount: totalNumberOfCubes,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if(snakePos.contains(index)){
                        return Tile(tileColor: Colors.orange);
                      }
                      else if(foodPos==index){
                        return Tile(tileColor: Colors.green);
                      }
                      else{
                        return Tile(tileColor: Colors.grey);
                      }
                    }),
              )),
          //play button
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Center(
              child: MaterialButton(
                color: gameHasStarted?Colors.white:Colors.orange,
                onPressed: ()=>gameHasStarted?(){}:startGame(),
                child: Text(
                  "Play",
                  style: TextStyle(
                    color:gameHasStarted?Colors.orange:Colors.white,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
