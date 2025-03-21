import '../bin/main_atm.dart';
import '../library/customer_model.dart';
import '../library/printer/handle_print.dart';
import 'mock_test_printer.dart';

class MockATM implements ATM {
  @override
  Customer? loggedInCustomer;

  @override
  // TODO: implement customers
  Map<String, Customer> get customers => {};

  @override
  void handleCommand(String input) {
    // TODO: implement handleCommand
  }

  @override
  // TODO: implement printer
  Printer get printer => TestPrinter();

  @override
  void run() {
    // TODO: implement run
  }

  @override
  void runAutomated(List<String> commands) {
    // TODO: implement runAutomated
  }
  
}