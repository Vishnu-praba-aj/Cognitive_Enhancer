import 'package:flutter/material.dart';

void main() {
  runApp(MazeGame());
}

class MazeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maze Game',
      home: MazeScreen(),
    );
  }
}

class MazeScreen extends StatefulWidget {
  @override
  _MazeScreenState createState() => _MazeScreenState();
}

class _MazeScreenState extends State<MazeScreen> {
  int playerX = 0;
  int playerY = 0;
  bool reachedDestination = false;
  DateTime? startTime;
  DateTime? endTime;

  // Define the maze layout here
  List<List<int>> maze = [
    [1, 1, 1, 1, 1],
    [0, 0, 1, 0, 1],
    [1, 1, 1, 0, 1],
    [1, 0, 0, 0, 1],
    [1, 1, 1, 1, 1],
  ];

  // Destination coordinates
  int destinationX = 4;
  int destinationY = 4;

  void movePlayer(int dx, int dy) {
    if (startTime == null) {
      startTime = DateTime.now();
    }
    int newX = playerX + dx;
    int newY = playerY + dy;
    if (_isWithinBounds(newX, newY) && _isValidMove(newX, newY)) {
      setState(() {
        playerX = newX;
        playerY = newY;
        if (playerX == destinationX && playerY == destinationY) {
          reachedDestination = true;
          endTime = DateTime.now();
          _showWinDialog();
        }
      });
    }
  }

  void _showWinDialog() {
    final timeTaken = endTime!.difference(startTime!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You won in ${timeTaken.inSeconds} seconds!'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        playerX = 0;
                        playerY = 0;
                        reachedDestination = false;
                        startTime = null;
                        endTime = null;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Play Again'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isWithinBounds(int x, int y) {
    return x >= 0 && x < maze.length && y >= 0 && y < maze[0].length;
  }

  bool _isValidMove(int x, int y) {
    return maze[x][y] == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maze Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: maze.length,
            ),
            itemCount: maze.length * maze[0].length,
            itemBuilder: (context, index) {
              int x = index ~/ maze.length;
              int y = index % maze.length;
              if (x == playerX && y == playerY) {
                return Container(
                  color: Colors.blue,
                  child: Icon(Icons.face),
                );
              } else if (x == destinationX && y == destinationY) {
                return Container(
                  color: Colors.green,
                  child: reachedDestination ? Icon(Icons.done) : null,
                );
              } else {
                return Container(
                  color: maze[x][y] == 1 ? Colors.black : Colors.white,
                );
              }
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_upward),
                onPressed: () => movePlayer(-1, 0),
              ),
              IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () => movePlayer(1, 0),
              ),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => movePlayer(0, -1),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => movePlayer(0, 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
