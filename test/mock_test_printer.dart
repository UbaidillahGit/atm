import '../library/printer/handle_print.dart';

class TestPrinter implements Printer {
  final List<String> printedMessage = [];

  @override
  printTxt(String txt) => printedMessage.add(txt);

  @override
  void printBalance(int balance) => print('Your balance is \$$balance');

  @override
  void printTransfer(int amount, String customerName) => print('Transferred \$$amount to $customerName');

  @override
  void printOwedTo(String customerName, int amount) => print('Owed \$$amount to $customerName');

  @override
  void printOwedFrom(String customerName, int amount) => print('Owed \$$amount from $customerName');

  @override
  void printInsufficientBalance() => print('Insufficient balance');

  @override
  void printSpace() => print('');
}