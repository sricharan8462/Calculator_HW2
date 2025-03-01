import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
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
        if (RegExp(r'[+\-*/]').hasMatch(value) &&
            input.isNotEmpty &&
            RegExp(r'[+\-*/]$').hasMatch(input)) {
          input = input.substring(0, input.length - 1) + value;
        } else if (value == ".") {
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
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Text(
                input,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Text(
                output,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white),
          Column(
            children: [
              buildButtonRow(["C", "/", "*", "-"], [Colors.red, Colors.orange, Colors.orange, Colors.orange]),
              buildButtonRow(["7", "8", "9", "+"], [Colors.grey[850]!, Colors.grey[850]!, Colors.grey[850]!, Colors.orange]),
              buildButtonRow(["4", "5", "6", "."], [Colors.grey[850]!, Colors.grey[850]!, Colors.grey[850]!, Colors.orange]),
              buildButtonRow(["1", "2", "3", "="], [Colors.grey[850]!, Colors.grey[850]!, Colors.grey[850]!, Colors.blue]),
              buildButtonRow(["0"], [Colors.grey[850]!]),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> values, List<Color> colors) {
    return Row(
      children: List.generate(values.length, (index) {
        return buildButton(values[index], colors[index]);
      }),
    );
  }

  Widget buildButton(String value, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () => onButtonPressed(value),
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 85,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 5, offset: Offset(2, 2)),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 30,
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
