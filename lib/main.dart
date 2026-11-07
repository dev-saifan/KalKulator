import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KalKulator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  String _operand = '';
  double? _firstNum;
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _display = '0';
        _expression = '';
        _firstNum = null;
        _operand = '';
        _shouldResetDisplay = false;
      } else if (value == '⌫') {
        if (_display.length > 1 && !_shouldResetDisplay) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (value == '+/-') {
        if (_display != '0') {
          if (_display.startsWith('-')) {
            _display = _display.substring(1);
          } else {
            _display = '-$_display';
          }
        }
      } else if (value == '%') {
        double val = double.tryParse(_display) ?? 0;
        _display = (val / 100).toString();
        if (_display.endsWith('.0')) {
          _display = _display.substring(0, _display.length - 2);
        }
      } else if (['+', '-', '×', '÷'].contains(value)) {
        _firstNum = double.tryParse(_display);
        _operand = value;
        _expression = '$_display $_operand';
        _shouldResetDisplay = true;
      } else if (value == '=') {
        if (_firstNum != null && _operand.isNotEmpty) {
          double secondNum = double.tryParse(_display) ?? 0;
          double result = 0;

          switch (_operand) {
            case '+':
              result = _firstNum! + secondNum;
              break;
            case '-':
              result = _firstNum! - secondNum;
              break;
            case '×':
              result = _firstNum! * secondNum;
              break;
            case '÷':
              result = secondNum != 0 ? _firstNum! / secondNum : double.nan;
              break;
          }

          if (result.isNaN) {
            _display = 'Error';
          } else {
            String resStr = result.toString();
            if (resStr.endsWith('.0')) {
              resStr = resStr.substring(0, resStr.length - 2);
            }
            _expression = '$_expression $_display =';
            _display = resStr;
          }

          _firstNum = null;
          _operand = '';
          _shouldResetDisplay = true;
        }
      } else {
        if (_display == '0' || _shouldResetDisplay) {
          _display = value == '.' ? '0.' : value;
          _shouldResetDisplay = false;
        } else {
          if (value == '.' && _display.contains('.')) return;
          _display += value;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? bg, Color? fg}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bg ?? const Color(0xFF333333),
              foregroundColor: fg ?? Colors.white,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
            ),
            onPressed: () => _onButtonPressed(text),
            child: Text(
              text,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orangeColor = const Color(0xFFFF9F0A);
    final lightGreyColor = const Color(0xFFA5A5A5);
    final darkGreyColor = const Color(0xFF333333);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with History icon and Custom Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.history, color: Colors.white, size: 28),
                  Image.asset(
                    'assets/calculator.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.calculate_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _display,
                        style: const TextStyle(
                          fontSize: 75,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton('⌫', bg: lightGreyColor, fg: Colors.black),
                      _buildButton('AC', bg: lightGreyColor, fg: Colors.black),
                      _buildButton('%', bg: lightGreyColor, fg: Colors.black),
                      _buildButton('÷', bg: orangeColor),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('7', bg: darkGreyColor),
                      _buildButton('8', bg: darkGreyColor),
                      _buildButton('9', bg: darkGreyColor),
                      _buildButton('×', bg: orangeColor),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('4', bg: darkGreyColor),
                      _buildButton('5', bg: darkGreyColor),
                      _buildButton('6', bg: darkGreyColor),
                      _buildButton('-', bg: orangeColor),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('1', bg: darkGreyColor),
                      _buildButton('2', bg: darkGreyColor),
                      _buildButton('3', bg: darkGreyColor),
                      _buildButton('+', bg: orangeColor),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('+/-', bg: darkGreyColor),
                      _buildButton('0', bg: darkGreyColor),
                      _buildButton('.', bg: darkGreyColor),
                      _buildButton('=', bg: orangeColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
