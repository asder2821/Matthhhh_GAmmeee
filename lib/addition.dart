import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Center(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'asset/math.png',
              height: 300,
              width: 300,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MathQuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: Colors.lightBlue,
              ),
              child: Text(
                'Play',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MathQuizScreen extends StatefulWidget {
  const MathQuizScreen({Key? key}) : super(key: key);

  @override
  State<MathQuizScreen> createState() => _MathQuizScreenState();
}

class _MathQuizScreenState extends State<MathQuizScreen> {
  List<String> numberpad = [
    '7', '8', '9', 'C',
    '4', '5', '6', 'Del',
    '1', '2', '3', '=',
    '0', '-',
  ];

  int timeLeft = 10; // Set the countdown time in seconds
  Timer? timer;
  int num1 = 1;
  int num2 = 1;
  String useranswer = '';
  var randomNumber = Random();
  List<String> operations = ['+', '-', '*'];
  String currentOperation = '+';

  int score = 0;
  Color answerBoxColor = Colors.blue; // Default color for the answer box

  void startTimer() {
    timer?.cancel(); // Cancel any existing timer
    timeLeft = 10; // Reset the timer to 10 seconds
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          showGameOver();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer when the screen is loaded
  }

  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        checkresult();
      } else if (button == 'C') {
        useranswer = '';
      } else if (button == 'Del') {
        if (useranswer.isNotEmpty) {
          useranswer = useranswer.substring(0, useranswer.length - 1);
        }
      } else if (useranswer.length < 3) {
        useranswer += button;
      }
    });
  }

  void checkresult() {
    if (num1 + num2 == int.parse(useranswer) ||
        num1 * num2 == int.parse(useranswer) ||
        num1 - num2 == int.parse(useranswer)) {
      timer?.cancel(); // Pause the timer
      setState(() {
        score++; // Increment the score
        answerBoxColor = Colors.blue; // Reset the color to blue
      });
      showDialog(
        context: context,
        builder: (context) {
          return Resultmessage(
            message: 'Correct!!',
            onTap: nextquestion,
            icon: Icons.arrow_forward,
          );
        },
      );
    } else {
      setState(() {
        answerBoxColor = Colors.red; // Change the color to red on a wrong answer
      });

      // Optionally reset the color back to normal after a delay
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          answerBoxColor = Colors.blue.withOpacity(0.6);
        });
      });
    }
  }


  void nextquestion() {
    Navigator.of(context).pop();
    setState(() {
      useranswer = '';
      num1 = randomNumber.nextInt(10);
      num2 = randomNumber.nextInt(10);
      currentOperation = operations[randomNumber.nextInt(operations.length)];
      answerBoxColor = Colors.blue; // Reset the color to blue for the next question
    });
    startTimer(); // Restart the timer
  }

  void backtothequestion() {
    Navigator.of(context).pop();
    setState(() {
      answerBoxColor = Colors.blue; // Reset the color to blue after retrying
    });
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[300],
          title: Text(
            'Game Over',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Time is up!\nYour score: $score',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to start screen
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.lightBlue,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Score: $score', // Display the score
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    'Time Left: $timeLeft', // Display the timer
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$num1 $currentOperation $num2 = ',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        height: 80,
                        width: 160,
                        decoration: BoxDecoration(
                          color: answerBoxColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            useranswer,
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                itemCount: numberpad.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    child: numberpad[index],
                    onTap: () => buttonTapped(numberpad[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Resultmessage extends StatelessWidget {
  final String message;
  final VoidCallback onTap;
  final IconData icon;

  const Resultmessage({
    Key? key,
    required this.message,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue,
      contentPadding: EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: onTap,
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String child;
  final VoidCallback onTap;
  var buttonColor = Colors.blue[400];

  MyButton({Key? key, required this.child, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child == 'C') {
      buttonColor = Colors.green;
    } else if (child == 'Del') {
      buttonColor = Colors.red;
    } else if (child == '=') {
      buttonColor = Colors.purple[800];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              child,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

