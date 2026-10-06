import 'dart:math';

class CalculatorLogic {
  static double? calculate(
    double firstNumber,
    double secondNumber,
    String operation,
  ) {
    if (operation == '+') {
      return firstNumber + secondNumber;
    }

    if (operation == '−') {
      return firstNumber - secondNumber;
    }

    if (operation == '×') {
      return firstNumber * secondNumber;
    }

    if (operation == '^') {
      return pow(firstNumber, secondNumber).toDouble();
    }

    if (operation == '÷') {
      // Делить на ноль нельзя
      if (secondNumber == 0) {
        return null;
      }

      return firstNumber / secondNumber;
    }

    // Если вдруг пришла неизвестная операция
    return null;
  }
}