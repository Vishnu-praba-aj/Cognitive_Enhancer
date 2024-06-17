import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MathQuizApp());
}

class MathQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MathQuizScreen(),
    );
  }
}

class MathQuizScreen extends StatefulWidget {
  @override
  _MathQuizScreenState createState() => _MathQuizScreenState();
}

class _MathQuizScreenState extends State<MathQuizScreen> {
  int num1 = 0;
  int num2 = 0;
  int answer = 0;
  List<String> options = [];
  Color optionColor = Colors.transparent; // Initialized optionColor
  int questionCount = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    if (questionCount == 10) {
      // If 10 questions have been answered, show the score and ask to play again
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Finished'),
            content: Text('Your score: $score out of 10'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Reset the quiz
                  setState(() {
                    questionCount = 0;
                    score = 0;
                    generateQuestion();
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Play Again'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        Random random = Random();
        num1 = random.nextInt(10); // Random number between 0 and 9
        num2 = random.nextInt(10);
        answer = num1 + num2;

        options.clear();
        options.add(answer.toString());
        while (options.length < 4) {
          int option = random.nextInt(19); // Random number between 0 and 18
          if (!options.contains(option.toString()) && option != answer) {
            options.add(option.toString());
          }
        }
        options.shuffle();
        if (questionCount < 10) { // Only reset optionColor if game is not finished
          optionColor = Colors.transparent;
        }
      });
    }
  }


  void checkAnswer(String selectedAnswer) {
    setState(() {
      final bool isCorrect = int.parse(selectedAnswer) == answer;
      optionColor = isCorrect ? Colors.green : Colors.red;
      if (isCorrect) {
        score++;
      }
      questionCount++;
    });
    if (questionCount == 10) {
      // If all 10 questions have been answered, show the score
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Finished'),
            content: Text('Your score: $score out of 10'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Reset the quiz
                  setState(() {
                    questionCount = 0;
                    score = 0;
                    generateQuestion();
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Play Again'),
              ),
            ],
          );
        },
      );
    } else {
      generateQuestion();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math Quiz'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$num1 + $num2 = ?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: options.map((option) {
                return ElevatedButton(
                  onPressed: () {
                    checkAnswer(option);
                  },
                  child: Text(
                    option,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      optionColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                generateQuestion();
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
