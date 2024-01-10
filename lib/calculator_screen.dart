import 'package:calculator_app/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "", operand = "", number2 = "";

  @override
  Widget build(BuildContext context) {
    //make button size to be responsuve based on UI
    final screen = MediaQuery.of(context).size; //gives screen size
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //Display Area
            Expanded(
              child: SingleChildScrollView(
                //default scroll from top
                reverse: true, //bottom to top scroll
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2", //Default 0
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ), //Buttons

            Wrap(
              children: Buttons.buttonValues
                  .map(
                    (value) => SizedBox(
                        width: [Buttons.num0, Buttons.clr, Buttons.calculate]
                                .contains(value)
                            ? screen.width / 2
                            : screen.width / 4,
                        height: screen.height / 8,
                        child: buttonView(value)),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buttonView(value) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        color: [Buttons.clr].contains(value)
            ? Colors.blueGrey
            : [
                Buttons.add,
                Buttons.subtract,
                Buttons.multiply,
                Buttons.divide,
                Buttons.decimal
              ].contains(value)
                ? Colors.grey
                : [Buttons.calculate].contains(value)
                    ? Colors.orange
                    : Colors.black87,
        clipBehavior: Clip
            .hardEdge, //On click of buttons, Splash effect was crossing the button.
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
            onTap: () => onBtnTap(value),
            child: Center(
                child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ))),
      ),
    );
  }

  // function called on Tap of Buttons
  void onBtnTap(String value) {
    if (value.contains(Buttons.clr)) {
      setState(() {
        number1 = "";
        operand = "";
        number2 = "";
      });
      return;
    }
    //Calculation on press of '=' button
    if (value.contains(Buttons.calculate)) {
      calculate();
      return;
    }
    displayValue(value);
  }

  // calculates the result
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Buttons.add:
        result = num1 + num2;
        break;
      case Buttons.subtract:
        result = num1 - num2;
        break;
      case Buttons.multiply:
        result = num1 * num2;
        break;
      case Buttons.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = result.toStringAsPrecision(3);
      operand = "";
      number2 = "";
    });
  }

  // appends value to the end
  void displayValue(String value) {
    // operand pressed
    if (value != Buttons.decimal && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        // calculate the equation before assigning new operand
        calculate();
      }
      operand = value;
    }
    // assign value to number1 variable
    else if (number1.isEmpty || operand.isEmpty) {
      number1 += value;
    }
    // assign value to number2 variable
    else if (number2.isEmpty || operand.isNotEmpty) {
      number2 += value;
    }
    setState(() {});
  }
}
