import 'package:test/test.dart';

import '../../bin/main_atm.dart';
import '../../library/commands/login_cmd.dart';
import '../../library/customer_model.dart';
import '../mock_test_printer.dart';

void main() {
  const randomCharacters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+[]{}|;:,.<>?';
  TestPrinter testPrinter = TestPrinter();
  final atm = ATM(printer: testPrinter);
  final loginCommand = LoginCommand(atm);

  group(
    'Login case-validation',
    () {
      // Loop test to handle not allowed names
      for (var name in loginCommand.listOfNotAllowedNames) {
        test('Invalid input name of "$name" is caught', () {
          testPrinter = TestPrinter();
          loginCommand.printer = testPrinter; // Set the printer to TestPrinter
          loginCommand.execute([name]);

          final expectedMessages = [
            'Please enter a valid name! \x1B[1m$name\x1B[0m is not allowed',
            'Only letters are allowed, any special character is prohibited',
          ];

          expect(testPrinter.printedMessage, expectedMessages);
          Future.delayed(Duration(milliseconds: 100));
        });
      }

      test('Invalid input name of random characters "$randomCharacters" is caught', () {
        testPrinter = TestPrinter();
        loginCommand.printer = testPrinter; // Set the printer to TestPrinter
        loginCommand.execute([randomCharacters]);

        final expectedMessages = [
          'Please enter a valid name! \x1B[1m$randomCharacters\x1B[0m is not allowed',
          'Only letters are allowed, any special character is prohibited',
        ];

        expect(testPrinter.printedMessage, expectedMessages);
        Future.delayed(Duration(milliseconds: 100));
      });

      test('Blank name is caught', () {
        final emptyName = List<String>.empty();
        final testPrinter = TestPrinter();
        final atm = ATM(printer: testPrinter);
        final loginCmd = LoginCommand(atm);
        loginCmd.printer = testPrinter; // Set the printer to TestPrinter
        loginCmd.execute(emptyName);

        final expectedMessages = ['Please input your name'];

        expect(testPrinter.printedMessage, expectedMessages);
      });
    },
  );

  group('Login Success', () {
    const name = 'elon';
    late TestPrinter testPrinter;
    late ATM atm;
    late LoginCommand loginCmd;

    void _reinitialize() {
      testPrinter = TestPrinter();
      atm = ATM(printer: testPrinter);
      loginCmd = LoginCommand(atm);
      loginCmd.printer = testPrinter;
    }

    test('Login with correct name', () {
      _reinitialize();
      loginCmd.execute([name]);
      final expectedMessages = ['Hello, $name!', 'Your balance is \$${atm.loggedInCustomer!.balance}'];
      expect(testPrinter.printedMessage, expectedMessages);
    });

    test('Already logged in', () {
      _reinitialize();
      // Set logged in Custmer
      atm.loggedInCustomer = Customer(name: name);
      loginCmd.execute([name]);

      final expectedMsg = ['You are already logged in as ${atm.loggedInCustomer!.name}'];
      expect(testPrinter.printedMessage, expectedMsg);
    });

    test('User logged in has owed to', () {
      _reinitialize();
      final customer = Customer(name: name);
      customer.balance = 100;
      customer.owedTo = {'Maye': 50};
      atm.customers[name] = customer;
      loginCmd.execute([name]);
      final expectedMessages = [
        'Hello, $name!',
        'Your balance is \$${atm.loggedInCustomer!.balance}',
        'Owed \$${atm.loggedInCustomer?.owedTo.values.first} to ${atm.loggedInCustomer?.owedTo.keys.first}'
      ];

      expect(testPrinter.printedMessage, expectedMessages);
    });

    test('User logged in has owed from', () {
      _reinitialize();
      final customer = Customer(name: name);
      customer.balance = 100;
      customer.owedFrom = {'Maye': 50};
      atm.customers[name] = customer;
      loginCmd.execute([name]);
      final expectedMessages = [
        'Hello, $name!',
        'Your balance is \$${atm.loggedInCustomer!.balance}',
        'Owed \$${atm.loggedInCustomer?.owedFrom.values.first} from ${atm.loggedInCustomer?.owedFrom.keys.first}'
      ];

      expect(testPrinter.printedMessage, expectedMessages);
    });
  });
  group(
    'ATM Tests',
    () {
      test('Customer can deposit money', () {
        final testPrinter = TestPrinter();
        final atm = ATM(printer: testPrinter);
        final customer = Customer(name: 'Alice');
        atm.customers['Alice'] = customer;
        atm.handleCommand('login Alice');
        atm.handleCommand('deposit 100');
        expect(customer.balance, 100);
      });

      test('Customer can withdraw money', () {
        final testPrinter = TestPrinter();
        final atm = ATM(printer: testPrinter);
        final customer = Customer(name: 'Alice');
        atm.customers['Alice'] = customer;
        atm.handleCommand('login Alice');
        atm.handleCommand('deposit 100');
        atm.handleCommand('withdraw 50');
        expect(customer.balance, 50);
      });

      test('Customer can transfer money', () {
        final testPrinter = TestPrinter();
        final atm = ATM(printer: testPrinter);
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

      test(
        'Invalid command is handled gracefully',
        () {
          final testPrinter = TestPrinter();
          final atm = ATM(printer: testPrinter);
          atm.handleCommand('invalidcommand');
          // Check for invalid command output
        },
      );
    },
  );
}
