import 'package:flutter/material.dart';
import 'calculator_logic.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() {
    return _CalculatorPageState();
  }
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  String expression = '';

  double? firstNumber;
  String? operation;

  bool startNewNumber = true;
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111318),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            bool isLandscape =
                constraints.maxWidth > constraints.maxHeight;

            return Column(
              children: [
                Expanded(
                  flex: isLandscape ? 2 : 3,
                  child: _buildDisplay(isLandscape),
                ),
                Expanded(
                  flex: isLandscape ? 8 : 7,
                  child: _buildKeyboard(isLandscape),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDisplay(bool isLandscape) {
    double resultFontSize;
    double expressionFontSize;
    double padding;

    if (isLandscape) {
      resultFontSize = 32;
      expressionFontSize = 14;
      padding = 6;
    } else {
      resultFontSize = 52;
      expressionFontSize = 20;
      padding = 20;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              expression,
              style: TextStyle(
                color: Colors.grey,
                fontSize: expressionFontSize,
              ),
            ),
            SizedBox(
              height: isLandscape ? 1 : 8,
            ),
            Text(
              display,
              style: TextStyle(
                color: Colors.white,
                fontSize: resultFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboard(bool isLandscape) {
    double gap;

    if (isLandscape) {
      gap = 3;
    } else {
      gap = 8;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: isLandscape ? 2 : 8,
      ),
      child: Column(
        children: [
          Expanded(
            child: _buildRow(['C', '+/-', '^', '÷']),
          ),
          SizedBox(height: gap),

          Expanded(
            child: _buildRow(['7', '8', '9', '×']),
          ),
          SizedBox(height: gap),

          Expanded(
            child: _buildRow(['4', '5', '6', '−']),
          ),
          SizedBox(height: gap),

          Expanded(
            child: _buildRow(['1', '2', '3', '+']),
          ),
          SizedBox(height: gap),

          Expanded(
            child: _buildRow(['0', '.', '', '=']),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    List<Widget> rowButtons = [];

    for (String text in buttons) {
      if (text.isEmpty) {
        rowButtons.add(
          const Expanded(
            child: SizedBox(),
          ),
        );
      } else {
        rowButtons.add(
          _buildButton(text),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rowButtons,
    );
  }

  Widget _buildButton(String text) {
    bool isOperation = _isOperationButton(text);

    Color buttonColor;

    if (isOperation) {
      buttonColor = Colors.orange;
    } else if (text == 'C' || text == '+/-') {
      buttonColor = const Color(0xFF55585E);
    } else {
      buttonColor = const Color(0xFF2A2D32);
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: ElevatedButton(
          onPressed: () {
            _onButtonPressed(text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isOperationButton(String text) {
    if (text == '+') {
      return true;
    }

    if (text == '^') {
      return true;
    }

    if (text == '−') {
      return true;
    }

    if (text == '×') {
      return true;
    }

    if (text == '÷') {
      return true;
    }

    if (text == '=') {
      return true;
    }

    return false;
  }

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _clearCalculator();
        return;
      }

      if (text == '+/-') {
        _changeSign();
        return;
      }

      if (text == '.') {
        _addDecimalPoint();
        return;
      }

      if (text == '+' ||
          text == '−' ||
          text == '×' ||
          text == '÷' ||
          text == '^') {
        _selectOperation(text);
        return;
      }

      if (text == '=') {
        _calculateResult();
        return;
      }

      _addDigit(text);
    });
  }

  void _addDigit(String digit) {
    if (hasError) {
      _clearCalculator();
    }

    if (startNewNumber) {
      display = digit;
      startNewNumber = false;
    } else {
      if (display == '0') {
        display = digit;
      } else {
        display = display + digit;
      }
    }

    _updateExpression();
  }

  void _addDecimalPoint() {
    if (hasError) {
      _clearCalculator();
    }

    if (startNewNumber) {
      display = '0.';
      startNewNumber = false;
    } else {
      if (!display.contains('.')) {
        display = display + '.';
      }
    }

    _updateExpression();
  }

  void _selectOperation(String selectedOperation) {
    double? number = double.tryParse(display);

    if (number == null) {
      return;
    }

    firstNumber = number;
    operation = selectedOperation;

    expression =
        _formatNumber(number) +
        ' ' +
        selectedOperation;

    startNewNumber = true;
  }

  void _calculateResult() {
    double? first = firstNumber;
    String? selectedOperation = operation;

    if (first == null) {
      return;
    }

    if (selectedOperation == null) {
      return;
    }

    if (startNewNumber) {
      return;
    }

    double? secondNumber = double.tryParse(display);

    if (secondNumber == null) {
      return;
    }

    String fullExpression =
        _formatNumber(first) +
        ' ' +
        selectedOperation +
        ' ' +
        _formatNumber(secondNumber) +
        ' =';

    double? result = CalculatorLogic.calculate(
      first,
      secondNumber,
      selectedOperation,
    );

    if (result == null) {
      expression = fullExpression;
      display = 'Ошибка';

      hasError = true;
      firstNumber = null;
      operation = null;
      startNewNumber = true;

      return;
    }

    expression = fullExpression;
    display = _formatNumber(result);

    firstNumber = null;
    operation = null;

    startNewNumber = true;
  }

  // Доп. задание: изменение знака
  void _changeSign() {
    if (hasError) {
      return;
    }

    double? number = double.tryParse(display);

    if (number == null) {
      return;
    }

    number = number * -1;

    display = _formatNumber(number);

    _updateExpression();
  }

  void _clearCalculator() {
    display = '0';
    expression = '';

    firstNumber = null;
    operation = null;

    startNewNumber = true;
    hasError = false;
  }

  void _updateExpression() {
    double? first = firstNumber;
    String? selectedOperation = operation;

    if (first == null) {
      return;
    }

    if (selectedOperation == null) {
      return;
    }

    expression =
        _formatNumber(first) +
        ' ' +
        selectedOperation +
        ' ' +
        display;
  }

  String _formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }

    String text = number.toStringAsFixed(8);

    // Убираем лишние нули в конце дробной части
    while (text.endsWith('0')) {
      text = text.substring(0, text.length - 1);
    }

    return text;
  }
}