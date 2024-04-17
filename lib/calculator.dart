import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/history.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String history = '';
  String expression = '';
  List<String> historyList = [];

  Widget calcButton(
      String text, Color color, Color textColor, int textSize, String value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (value == 'AC') {
            expression = '';
            history = '';
          } else if (value == '⌫') {
            if (expression.isNotEmpty) {
              expression = expression.substring(0, expression.length - 1);
            } else if (history.isNotEmpty) {
              history = history.substring(0, history.length - 1);
            }
          } else if (value == '=') {
            try {
              Parser p = Parser();
              Expression ex = p.parse(expression);
              ContextModel cm = ContextModel();
              double eval = ex.evaluate(EvaluationType.REAL, cm);

              String historyItem = '$expression = $eval';
              history = '$expression ';
              expression = eval.toString();
              historyList.insert(0, historyItem);
            } catch (e) {
              expression = 'Error';
            }
          } else if (value == '%') {
            try {
              Parser p = Parser();
              Expression ex = p.parse(expression);
              ContextModel cm = ContextModel();
              double eval = ex.evaluate(EvaluationType.REAL, cm);
              eval = eval / 100;
              expression = eval.toString();
            } catch (e) {
              expression = 'Error';
            }
          } else if (value == 'sin' || value == 'cos' || value == 'tan') {
            expression += '$value(';
          } else if (value == '()') {
            if (!expression.contains('sin') &&
                !expression.contains('cos') &&
                !expression.contains('tan')) {
              if (expression.isEmpty || expression.endsWith('(')) {
                expression += '(';
              } else {
                expression += ')';
              }
            } else {
              expression += ')';
            }
          } else {
            expression += value;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: color,
        padding: const EdgeInsets.all(15),
        fixedSize: const Size(70, 70),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 100,
            child: Text(
              history,
              style: const TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: textSize.toDouble(),
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  _navigateToHistoryScreen(BuildContext context) async {
    final selectedResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(historyList: historyList),
      ),
    );

    if (selectedResult != null) {
      setState(() {
        expression = selectedResult as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4B4C6A),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Calculator'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _navigateToHistoryScreen(context);
              });
            },
            icon: const Icon(Icons.history),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 30,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          history,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 110,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          expression,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 77,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('AC', Colors.grey, Colors.white, 30, 'AC'),
                calcButton('⌫', Colors.grey, Colors.white, 30, '⌫'),
                calcButton('()', Colors.grey, Colors.white, 35, '()'),
                calcButton('/', Colors.amber, Colors.white, 35, '/'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('sin', Colors.grey, Colors.white, 23, 'sin'),
                calcButton('cos', Colors.grey, Colors.white, 23, 'cos'),
                calcButton('tan', Colors.grey, Colors.white, 23, 'tan'),
                calcButton('%', Colors.amber, Colors.white, 35, '%'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('7', Colors.grey, Colors.white, 35, '7'),
                calcButton('8', Colors.grey, Colors.white, 35, '8'),
                calcButton('9', Colors.grey, Colors.white, 35, '9'),
                calcButton('x', Colors.amber, Colors.white, 35, '*'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('4', Colors.grey, Colors.white, 35, '4'),
                calcButton('5', Colors.grey, Colors.white, 35, '5'),
                calcButton('6', Colors.grey, Colors.white, 35, '6'),
                calcButton('-', Colors.amber, Colors.white, 35, '-'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcButton('1', Colors.grey, Colors.white, 35, '1'),
                calcButton('2', Colors.grey, Colors.white, 35, '2'),
                calcButton('3', Colors.grey, Colors.white, 35, '3'),
                calcButton('+', Colors.amber, Colors.white, 35, '+'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      expression += '0';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(34, 20, 128, 20),
                    backgroundColor: Colors.grey[850],
                    shape: const StadiumBorder(),
                  ),
                  child: const Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                calcButton('.', Colors.grey, Colors.white, 35, '.'),
                calcButton('=', Colors.amber, Colors.white, 35, '='),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
