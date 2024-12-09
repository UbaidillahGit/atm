
import 'package:test/test.dart';
import '../bin/main_atm.dart';
import '../library/customer_model.dart';
import '../library/printer/handle_print.dart';

class TestPrinter implements Printer {
  @override
  void printTxt(String txt) => printTxt(txt);

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

void main() {
  // final testPrinter = TestPrinter();
  group('ATM Tests', () {
    test('Customer can deposit money', () {
      final atm = ATM();
      final customer = Customer(name: 'Alice');
      atm.customers['Alice'] = customer;
      atm.handleCommand('login Alice');
      atm.handleCommand('deposit 100');
      expect(customer.balance, 100);
    });

    test('Customer can withdraw money', () {
      final atm = ATM();
      final customer = Customer(name: 'Alice');
      atm.customers['Alice'] = customer;
      atm.handleCommand('login Alice');
      atm.handleCommand('deposit 100');
      atm.handleCommand('withdraw 50');
      expect(customer.balance, 50);
    });

    test('Customer can transfer money', () {
      final atm = ATM();
      final alice = Customer(name: 'Alice');
      final bob = Customer(name: 'Bob');
      atm.customers['Alice'] = alice;
      atm.customers['Bob'] = bob;
      atm.handleCommand('login Alice');
      atm.handleCommand('deposit 100');
      atm.handleCommand('transfer Bob 50');
      expect(alice.balance, 50);
      expect(bob.balance, 50);
    });

    test('Invalid command is handled gracefully', () {
      final atm = ATM();
      atm.handleCommand('invalidcommand');
      // Check for invalid command output
    });
  });
}