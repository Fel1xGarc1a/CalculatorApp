import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Calculator App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _displayValue = '0';
  double _firstOperand = 0;
  String _operator = '';
  bool _shouldResetDisplay = true;
  bool _operationCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Display area
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomRight,
            height: 100,
            width: double.infinity,
            color: Colors.grey[200],
            child: Text(
              _displayValue,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Calculator buttons grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(8.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: [
                // First row
                buildButton('7'),
                buildButton('8'),
                buildButton('9'),
                buildButton('/'),
                
                // Second row
                buildButton('4'),
                buildButton('5'),
                buildButton('6'),
                buildButton('*'),
                
                // Third row
                buildButton('1'),
                buildButton('2'),
                buildButton('3'),
                buildButton('-'),
                
                // Fourth row
                buildButton('0'),
                buildButton('C'),
                buildButton('='),
                buildButton('+'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget buildButton(String buttonText) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          // Handle different button types
          if (buttonText == 'C') {
            _displayValue = '0';
            _firstOperand = 0;
            _operator = '';
            _shouldResetDisplay = true;
            _operationCompleted = false;
          } else if (buttonText == '=') {
            if (_operator.isNotEmpty) {
              final secondOperand = double.parse(_displayValue);
              final result = _calculate(_firstOperand, secondOperand, _operator);
              _displayValue = result.toString();
              // Remove decimal point if result is a whole number
              if (_displayValue.endsWith('.0')) {
                _displayValue = _displayValue.substring(0, _displayValue.length - 2);
              }
              _operator = '';
              _operationCompleted = true;
            }
          } else if (buttonText == '+' || 
                    buttonText == '-' || 
                    buttonText == '*' || 
                    buttonText == '/') {
            // Handle operator
            if (!_operationCompleted && _operator.isNotEmpty) {
              // Calculate previous operation if chaining calculations
              final secondOperand = double.parse(_displayValue);
              final result = _calculate(_firstOperand, secondOperand, _operator);
              _displayValue = result.toString();
              if (_displayValue.endsWith('.0')) {
                _displayValue = _displayValue.substring(0, _displayValue.length - 2);
              }
            }
            _firstOperand = double.parse(_displayValue);
            _operator = buttonText;
            _shouldResetDisplay = true;
            _operationCompleted = false;
          } else {
            // Handle number input
            if (_shouldResetDisplay || _displayValue == '0' || _operationCompleted) {
              _displayValue = buttonText;
              _shouldResetDisplay = false;
              _operationCompleted = false;
            } else {
              _displayValue += buttonText;
            }
          }
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  double _calculate(double a, double b, String operator) {
    switch (operator) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return b != 0 ? a / b : 0; // Prevent division by zero
      default:
        return b;
    }
  }
}
