import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "";
  String output = "";

  void onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        output = "";
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(input);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          output = eval.toString();
          input = output;
        } catch (e) {
          output = "Error";
        }
      } else {
        input += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Text(
                input,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Text(
                output,
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.greenAccent),
              ),
            ),
          ),
          Divider(color: Colors.white),
          Column(
            children: [
              Row(children: [buildButton("7"), buildButton("8"), buildButton("9"), buildButton("/")]),
              Row(children: [buildButton("4"), buildButton("5"), buildButton("6"), buildButton("*")]),
              Row(children: [buildButton("1"), buildButton("2"), buildButton("3"), buildButton("-")]),
              Row(children: [buildButton("0"), buildButton("."), buildButton("="), buildButton("+")]),
              Row(children: [buildButton("C")]),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String value) {
    return Expanded(
      child: InkWell(
        onTap: () => onButtonPressed(value),
        child: Container(
          margin: EdgeInsets.all(8.0),
          height: 75,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

