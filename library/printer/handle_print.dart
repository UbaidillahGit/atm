import 'dart:io';

/// An abstract class that defines various print methods for handling different
/// types of print operations. This class is designed to reduce the use of 
/// [import 'dart:io';] across multiple files by centralizing print functionality.
/// 
abstract class Printer {
  void printTxt(String txt);
  void printBalance(int balance);
  void printTransfer(int amount, String customerName);
  void printOwedTo(String customerName, int amount);
  void printOwedFrom(String customerName, int amount);
  void printInsufficientBalance();
  void printSpace();
}

class ConsolePrinter implements Printer {
  @override
  void printTxt(String txt) => stdout.writeln(txt);

  @override
  void printBalance(int balance) => stdout.writeln('Your balance is \$$balance');

  @override
  void printTransfer(int amount, String customerName) => stdout.writeln('Transferred \$$amount to $customerName');

  @override
  void printOwedTo(String customerName, int amount) => stdout.writeln('Owed \$$amount to $customerName');

  @override
  void printOwedFrom(String customerName, int amount) => stdout.writeln('Owed \$$amount from $customerName');

  @override
  void printInsufficientBalance() => stdout.writeln('Insufficient balance');

  @override
  void printSpace() => stdout.writeln('');
}
