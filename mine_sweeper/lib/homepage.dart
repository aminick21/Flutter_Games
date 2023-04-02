import 'package:flutter/material.dart';
import 'package:mine_sweeper/bomb_box.dart';

import 'box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int rows=10;
  int totalBoxes=10*10;

  List<int> bombPos=[4,68,40,36,22,73];
  bool bombReveal=false;
  //[index,revealStatus]
  var squareStatus=[];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i =0;i<totalBoxes;i++){
      squareStatus.add([i,false]);
    }
    scanBombs();
  }


  scanBombs(){
    for(int i=0;i<totalBoxes;i++){
      int numberOfBombsAround=0;

    //  left
      if(bombPos.contains(i-1)&& i%rows!=0){
        numberOfBombsAround++;
      }
    //  top-left
      if(bombPos.contains(i-1-rows)&& i%rows!=0 && i>=rows){
        numberOfBombsAround++;
      }
    //  right
      if(bombPos.contains(i+1)&& i%rows!=9){
        numberOfBombsAround++;
      }
    //  top-right
      if(bombPos.contains(i+1-rows)&& i%rows!=9 && i>=rows){
        numberOfBombsAround++;
      }
    //  top
      if(bombPos.contains(i-rows)&& i>=rows){
        numberOfBombsAround++;
      }
    //  bottom
      if(bombPos.contains(i+rows)&& i+rows<totalBoxes){
        numberOfBombsAround++;
      }
    //  bottom-left
      if(bombPos.contains(i-1+rows)&& i%rows!=0 && i+rows<totalBoxes){
        numberOfBombsAround++;
      }
    //  bottom-right
      if(bombPos.contains(i+1+rows)&& i%rows!=9 && i+rows<totalBoxes){
        numberOfBombsAround++;
      }
      squareStatus[i][0]=numberOfBombsAround;
    }
  }

  revealBoxes(int index){

    if(squareStatus[index][0]!=0){
      setState(() {
        squareStatus[index][1]=true;
      });
    }
    else if(squareStatus[index][0]==0){
      setState(() {
        //reveal current box
        squareStatus[index][1]=true;
        //  left
        if(index%rows!=0){
          //recusing if left box is a 0
          if(squareStatus[index-1][0]==0&&squareStatus[index-1][1]==false){
            revealBoxes(index-1);}
          // reveal if its >0
            squareStatus[index-1][1]=true;
        }
        //  right
        if(index%rows!=9){
          if(squareStatus[index+1][0]==0&&squareStatus[index+1][1]==false){
            revealBoxes(index+1);}
          // reveal if its >0
          squareStatus[index+1][1]=true;
        }
        //  top
        if(index>=rows){
          if(squareStatus[index-rows][0]==0&&squareStatus[index-rows][1]==false){
            revealBoxes(index-rows);}
          // reveal if its >0
          squareStatus[index-rows][1]=true;
        }
        //  bottom
        if(index+rows<totalBoxes){
          if(squareStatus[index+rows][0]==0&&squareStatus[index+rows][1]==false){
            revealBoxes(index+rows);}
          // reveal if its >0
          squareStatus[index+rows][1]=true;
        }
        //  top left
        if(index%rows!=0&&index>=rows){
          if(squareStatus[index-1-rows][0]==0&&squareStatus[index-1-rows][1]==false){
            revealBoxes(index-1-rows);}
          // reveal if its >0
          squareStatus[index-1-rows][1]=true;

        }
        //  top right
        if(index%rows!=9&&index>=rows){
          if(squareStatus[index+1-rows][0]==0&&squareStatus[index+1-rows][1]==false){
            revealBoxes(index+1-rows);}
          // reveal if its >0
          squareStatus[index+1-rows][1]=true;
        }


      //  bottom left
        if(index%rows!=0&&index+rows<totalBoxes){
          if(squareStatus[index-1+rows][0]==0&&squareStatus[index-1+rows][1]==false){
            revealBoxes(index-1+rows);}
          // reveal if its >0
          squareStatus[index-1+rows][1]=true;
        }

      //  bottom right
        if(index%rows!=9&&index+rows<totalBoxes){
          if(squareStatus[index+1+rows][0]==0&&squareStatus[index+1+rows][1]==false){
            revealBoxes(index+1+rows);}
          // reveal if its >0
          squareStatus[index+1+rows][1]=true;
        }

      });

    }


  }

  gameOver(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('G A M E  O V E R !'),
      );
    }).then((value) => restartGame());
  }

  restartGame(){
    setState(() {
      bombReveal=false;
      for(int i=0;i<totalBoxes;i++){
        squareStatus[i][1]=false;
      }
    });
  }

  playerWon(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Y O U  W O N !'),
      );
    }).then((value) => restartGame());
  }

  checkWinner(){
    int checkedBoxes=0;
    for(int i=0;i<totalBoxes;i++){
      if(squareStatus[i][1]==true){
        checkedBoxes++;
      }
    }
    if(totalBoxes-checkedBoxes==bombPos.length){
      playerWon();
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          children: [
            //upper panel
            Container(height: 150,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bombPos.length.toString(),style: TextStyle(fontSize: 40),),
                    Text('B O M B',)
                  ],
                ),

                //button to refresh game

                GestureDetector(
                  onTap: (){
                    restartGame();
                  },
                  child: Card(color: Colors.grey[700],
                      child:Icon(Icons.refresh,size: 40,color: Colors.white,),
               ),
                ),

                //time remaining
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('5',style: TextStyle(fontSize: 40),),
                    Text('T I M E',)
                  ],
                )
              ],
            ),
            ),


          //  main grid
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: totalBoxes,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: rows,),
                  itemBuilder: (context,index){

                  if(bombPos.contains(index)){
                    return BombBox(
                      function:(){
                        setState(() {
                          bombReveal=true;
                        });
                        gameOver();
                      },
                        reveal: bombReveal);
                  }
                  else
                    {
                      return MyBox(
                          child:squareStatus[index][0] ,
                          reveal: squareStatus[index][1],
                          function: (){
                            revealBoxes(index);
                            checkWinner();
                          }

                      );
                    }

              }),
            ),


            //bottom text
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('M I N E S W E E P E R',),
            ),
          ],
        ),
      ),
    );
  }
}
