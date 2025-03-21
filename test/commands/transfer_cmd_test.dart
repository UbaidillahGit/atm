import 'package:test/test.dart';

import '../../bin/main_atm.dart';
import '../../library/commands/transfer_cmd.dart';
import '../../library/customer_model.dart';
import '../mock_test_printer.dart';

// class MockATM extends Mock

void main() {
  const custName = 'elon';
  final loggedInCustomer = Customer(name: custName);
  late TestPrinter testPrinter;
  late ATM atm;
  late TransferCommand transferCommand;

  group('Test negative case', () {
    setUp(() {
      testPrinter = TestPrinter();
      atm = ATM(printer: testPrinter);
      transferCommand = TransferCommand(atm);
      transferCommand.printer = testPrinter;
    });

    test('Login first to transfer', () {
      transferCommand.execute([]);
      final expectedMessages = ['Please login first to transfer'];
      expect(testPrinter.printedMessage, expectedMessages);
    });

    test('Invalid command is caught', () {
      const invalidCmd = ['', ''];
      transferCommand.atm.loggedInCustomer = loggedInCustomer;
      transferCommand.execute(invalidCmd);
      final expectedMessages = ['Please input correct transfer command e.g. "transfer Elon 50".'];
      expect(testPrinter.printedMessage, expectedMessages);
    });

    test('Invalid transfer to it self is caught', () {
      transferCommand.atm.loggedInCustomer = loggedInCustomer;
      transferCommand.execute(['elon', '90']);
      final expectedMessages = ['You cannot transfer to yourself'];
      expect(testPrinter.printedMessage, expectedMessages);
    });

    test('Prohibited numeric on name is caught', () {
      transferCommand.atm.loggedInCustomer = loggedInCustomer;
      transferCommand.execute(['90', '90']);
      final expectedMessages = ['Please input a correct name (any numeric or whitespace on name is prohibited).'];
      expect(testPrinter.printedMessage, expectedMessages);
    });

    test('Invalid amount input is caught', () {
      transferCommand.atm.loggedInCustomer = loggedInCustomer;
      transferCommand.execute(['io', '']);
      final expectedMessages = ['Please input correct transfer command e.g. "transfer Elon 50".'];
      expect(testPrinter.printedMessage, expectedMessages);
    });

    test('Catch transfer to other if current owed not settled yet', () {
      loggedInCustomer.owedTo = {'gates': 90};
      transferCommand.atm.loggedInCustomer = loggedInCustomer;
      transferCommand.execute(['zukerberg', '100']);
      final custNameOfOwedTo = loggedInCustomer.owedTo.keys.first;
      final expectedMessages = ['Not allowed transfer to other!', 'You need to settled the owed to $custNameOfOwedTo first'];
      expect(testPrinter.printedMessage, expectedMessages);
    });
  });

  group('Success Command ', () {
    Customer sourceCustomer;
    Customer targetCustomer;

    setUp(() {
      testPrinter = TestPrinter();
      atm = ATM(printer: testPrinter);
      // loggedInCustomer.balance = 10;
      atm.loggedInCustomer = loggedInCustomer;
      transferCommand = TransferCommand(atm);
      transferCommand.printer = testPrinter;
      sourceCustomer = Customer(name: 'source');
      targetCustomer = Customer(name: 'target');
      sourceCustomer.balance = 50;
      targetCustomer.balance = 100;
      sourceCustomer.printer = testPrinter;
    });

    test('Transfer success', () {
      targetCustomer = Customer(name: 'target');
      // atm.customers[targetCustomer.name] = targetCustomer;
      transferCommand.execute(['target', '50']);
      final expectedMessages = ['Please input correct transfer command e.g. "transfer Elon 50".'];
      expect(testPrinter, expectedMessages);
      // expect(targetCustomer.balance, 150);
    });

    test('Insufficient balance', () {
      // sourceCustomer.
    });
  });
}
