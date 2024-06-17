import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(OrderingGame());
}

class OrderingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Analysis'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back to the previous screen
            },
          ),
        ),
        body: Center(
          child: OrderingScreen(),
        ),
      ),
    );
  }
}

class OrderingScreen extends StatefulWidget {
  @override
  _OrderingScreenState createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  List<String> objects = ["Hello", "Joy", "Glass", "Bicycle", "Bottle"];
  List<String> orderedObjects = [];
  bool gameOver = false;
  String feedback = '';
  DateTime? startTime;
  DateTime? endTime;
  int coins = 0;
  int timeTaken = 0;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          'Order the Words lexicographically:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Container(
          height: 200,
          child: ListView.builder(
            itemCount: orderedObjects.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.blue[100],
                child: ListTile(
                  title: Text(orderedObjects[index]),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 200,
          child: ListView.builder(
            itemCount: objects.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.green[100],
                child: ListTile(
                  title: Text(objects[index]),
                  onTap: () {
                    if (!gameOver) {
                      setState(() {
                        orderedObjects.add(objects[index]);
                        objects.removeAt(index);
                      });
                      if (objects.isEmpty) {
                        setState(() {
                          gameOver = true;
                          endTime = DateTime.now();
                          calculateTimeAndScore();
                          checkOrder();
                        });
                      }
                    }
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Text(
          feedback,
          style: TextStyle(
            color: feedback == 'Congratulations!' ? Colors.green : Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Coins: $coins',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        if (gameOver)
          Column(
            children: [
              Text(
                'Time taken: $timeTaken seconds',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    restartGame();
                  });
                },
                child: Text('Play Again'),
              ),
            ],
          ),
      ],
    );
  }

  void restartGame() {
    // Resetting the game
    objects = generateRandomWords();
    orderedObjects.clear();
    gameOver = false;
    feedback = '';
    startTime = DateTime.now();
    endTime = null;
    coins = 0;
    timeTaken = 0;
  }

  void checkOrder() {
    bool correctOrder = true;
    for (int i = 0; i < orderedObjects.length - 1; i++) {
      if (orderedObjects[i].compareTo(orderedObjects[i + 1]) > 0) {
        correctOrder = false;
        break;
      }
    }

    if (correctOrder) {
      feedback = 'Congratulations!';
      calculateTimeAndScore();
    } else {
      feedback = 'Oops, try again';
      coins = 0; // Set coins to 0 if the player loses
    }
  }

  void calculateTimeAndScore() {
    if (startTime != null && endTime != null) {
      timeTaken = endTime!.difference(startTime!).inSeconds;
      // Coins are inversely proportional to the time taken
      coins = timeTaken > 0 ? 1000 ~/ timeTaken : 0;
    }
  }

  List<String> generateRandomWords() {
    List<String> words = ["Hello", "Joy", "Glass", "Bicycle", "Bottle"];
    words.shuffle();
    return words;
  }
}