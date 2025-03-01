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
      theme: ThemeData.dark(),
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
          if (input.isNotEmpty && !RegExp(r'[+\-*/]$').hasMatch(input)) {
            Parser p = Parser();
            Expression exp = p.parse(input);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);

            if (eval.toString() == "Infinity" || eval.toString() == "NaN") {
              output = "Error";
            } else {
              output = eval.toString();
            }
            input = output;
          }
        } catch (e) {
          output = "Error";
        }
      } else {
        // Prevent consecutive operators (e.g., "5 ++ 3" is not allowed)
        if (RegExp(r'[+\-*/]').hasMatch(value) &&
            input.isNotEmpty &&
            RegExp(r'[+\-*/]$').hasMatch(input)) {
          input = input.substring(0, input.length - 1) + value;
        }
        // Prevent multiple decimals in a single number
        else if (value == ".") {
          List<String> parts = input.split(RegExp(r'[+\-*/]'));
          String lastPart = parts.isNotEmpty ? parts.last : "";
          if (!lastPart.contains(".")) {
            input += value;
          }
        } else {
          input += value;
        }
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
              padding: const EdgeInsets.all(20),
              child: Text(
                input,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                output,
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white),
          Column(
            children: [
              Row(
                children: [
                  buildButton("C", Colors.red),
                  buildButton("/", Colors.orange),
                  buildButton("*", Colors.orange),
                  buildButton("-", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("7", Colors.grey[850]!),
                  buildButton("8", Colors.grey[850]!),
                  buildButton("9", Colors.grey[850]!),
                  buildButton("+", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("4", Colors.grey[850]!),
                  buildButton("5", Colors.grey[850]!),
                  buildButton("6", Colors.grey[850]!),
                  buildButton(".", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("1", Colors.grey[850]!),
                  buildButton("2", Colors.grey[850]!),
                  buildButton("3", Colors.grey[850]!),
                  buildButton("=", Colors.blue),
                ],
              ),
              Row(children: [buildButton("0", Colors.grey[850]!)]),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String value, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () => onButtonPressed(value),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          height: 75,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
