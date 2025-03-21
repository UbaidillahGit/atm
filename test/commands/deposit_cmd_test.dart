import 'package:test/test.dart';
import '../../bin/main_atm.dart';
import '../../library/commands/deposit_cmd.dart';
import '../../library/customer_model.dart';
import '../mock_test_printer.dart';

void main() {
  const custName = 'elon';
  final loggedInCustomer = Customer(name: custName);
  late TestPrinter testPrinter;
  late ATM atm;
  late DepositCommand depostCmd;

  _init() {
    testPrinter = TestPrinter();
    atm = ATM(printer: testPrinter);
    depostCmd = DepositCommand(atm);
    depostCmd.printer = testPrinter;
  }

  group('group name', () {
    test('Login first to deposit', () {
      _init();
      depostCmd.execute([]);

      final expectedMsg = ['Please login first to deposit'];

      expect(testPrinter.printedMessage, expectedMsg);
    });

    test('Input deposit amount', () {
      _init();

      depostCmd.atm.loggedInCustomer = loggedInCustomer;
      depostCmd.execute([]);

      final expectedMsg = ['Please input your deposit amount'];

      expect(testPrinter.printedMessage, expectedMsg);
    });

    test('Input valid number for deposit', () {
      _init();
      atm.loggedInCustomer = loggedInCustomer;
      depostCmd.execute(['io']);

      final expectedMessages = ['Please input a valid number for the deposit amount'];
      expect(testPrinter.printedMessage, expectedMessages);
    });
  });
}
