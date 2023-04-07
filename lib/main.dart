import 'package:flutter/material.dart';
import 'package:flutter_application_1/questions.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Erdem\'s Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(title: 'Erdem\'s Quiz App'),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;

  HomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Start Quiz"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizPage()),
            );
          },
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int _score = 0;
  List<dynamic> answers = [];

  void _answerQuestion(String answer) {
    setState(() {
      answers.add(answer);
      _score += answer == questions[_currentIndex]['answer'] ? 1 : 0;
      _currentIndex++;
      if (_currentIndex >= questions.length) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              score: _score,
              totalQuestions: questions.length,
              answers: answers,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questions[_currentIndex]['question'],
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 12.0),
            ...List<Widget>.from(
              questions[_currentIndex]['options'].map(
                (option) => ElevatedButton(
                  child: Text(option),
                  onPressed: () => _answerQuestion(option),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<dynamic> answers;

  ResultsPage({
    required this.score,
    required this.totalQuestions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    String greeting = "";

    if (score == totalQuestions) {
      greeting = "Excellent! You got $score out of $totalQuestions";
    } else if (score >= (totalQuestions / 2)) {
      greeting = "Good job! You got $score out of $totalQuestions";
    } else {
      greeting = "You got $score out of $totalQuestions";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mert\'s Quiz App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              greeting,
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            Text(
              "Total score: $score out of $totalQuestions",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24.0),
            Text(
              "Correct answers:",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              children: List<Widget>.generate(
                questions.length,
                (index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      questions[index]['question'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      questions[index]['answer'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      answers[index],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: answers[index] == questions[index]['answer']
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
