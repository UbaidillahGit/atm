import '../library/customer_model.dart';
import '../library/printer/handle_print.dart';
import 'mock_test_printer.dart';

class MockCustomer implements Customer {
  @override
  int balance = 0;

  @override
  String name = '';

  @override
  Map<String, int> owedFrom = {};

  @override
  Map<String, int> owedTo = {};

  @override
  Printer printer = TestPrinter();

  @override
  void deposit(int amount) {
    // TODO: implement deposit
  }

  @override
  void settleDebtAndDeposit({required Customer customer, required int amount}) {
    // TODO: implement settleDebtAndDeposit
  }

  @override
  void transfer(Customer customer, int amount) {
    // TODO: implement transfer
  }

  @override
  void withdraw(int amount) {
    // TODO: implement withdraw
  }
}