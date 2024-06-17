import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoryGameScreen(),
    );
  }
}

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<int> _tileIndices;
  late List<bool> _matchedTiles;
  late List<bool> _flippedTiles;
  int? _firstSelectedTileIndex;
  int? _secondSelectedTileIndex;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _tileIndices = List.generate(16, (index) => index ~/ 2);
    _tileIndices.shuffle();
    _matchedTiles = List.filled(16, false);
    _flippedTiles = List.filled(16, false);
    _firstSelectedTileIndex = null;
    _secondSelectedTileIndex = null;
    _gameOver = false;
  }

  void _onTileTap(int index) {
    if (_gameOver || _matchedTiles[index]) return;

    setState(() {
      if (_firstSelectedTileIndex == null) {
        _firstSelectedTileIndex = index;
      } else if (_secondSelectedTileIndex == null) {
        _secondSelectedTileIndex = index;
        _checkForMatch();
      }
      _flippedTiles[index] = true;
    });
  }

  void _checkForMatch() {
    if (_tileIndices[_firstSelectedTileIndex!] ==
        _tileIndices[_secondSelectedTileIndex!]) {
      _matchedTiles[_firstSelectedTileIndex!] = true;
      _matchedTiles[_secondSelectedTileIndex!] = true;
      if (!_matchedTiles.contains(false)) {
        _gameOver = true;
        _showGameOverDialog();
      }
    } else {
      _flipBackUnmatchedTiles();
    }
    _firstSelectedTileIndex = null;
    _secondSelectedTileIndex = null;
  }

  void _flipBackUnmatchedTiles() {
    Future.delayed(Duration(milliseconds: 1000), () {
      final firstIndex = _firstSelectedTileIndex;
      final secondIndex = _secondSelectedTileIndex;
      if (firstIndex != null && secondIndex != null) {
        setState(() {
          // Flip back the unmatched tiles
          if (!_matchedTiles[firstIndex] && !_matchedTiles[secondIndex]) {
            _flippedTiles[firstIndex] = false;
            _flippedTiles[secondIndex] = false;
          }
          _firstSelectedTileIndex = null;
          _secondSelectedTileIndex = null;
        });
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You won the game.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: _tileIndices.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onTileTap(index),
            child: Container(
              color: _flippedTiles[index] ? Colors.blue : Colors.grey,
              margin: EdgeInsets.all(4),
              child: Center(
                child: _flippedTiles[index]
                    ? _matchedTiles[index]
                    ? Icon(Icons.check, color: Colors.white)
                    : Text(
                  _tileIndices[index].toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                )
                    : SizedBox(), // Empty SizedBox when tile not flipped
              ),
            ),
          );
        },
      ),
    );
  }
}
