import '../../bin/main_atm.dart';
import '../customer_model.dart';
import '../printer/handle_print.dart';

/// This LoginCommand class handles the login process for the ATM system. It performs the following steps:
/// 1. Checks if a user is already logged in. If so, it prints a message and returns.
/// 2. Validates the input name provided in the [args] list. If the name is empty or invalid, it prints an error message and returns.
/// 3. Ensures the input name contains only letters and does not include any prohibited names listed in [listOfNotAllowedNames].
/// 4. Logs in the customer by adding them to the ATM's customer list if they are not already present.
/// 5. Prints a welcome message and the customer's balance.
/// 6. If the customer owes money to someone, it prints the amount owed and the name of the person.
/// 7. If someone owes money to the customer, it prints the amount owed and the name of the person.
///
/// [args] - A list of strings containing the input name for the login command.
///
class LoginCommand extends Command {
  final ATM atm;
  Printer printer = ConsolePrinter();

  LoginCommand(this.atm);
  final List<String> listOfNotAllowedNames = [
    'login',
    'deposit',
    'withdraw',
    'transfer',
    'logout',
    'name',
    'username',
    'atm',
    'owed',
    'balance',
  ];

  @override
  void execute(List<String> args) {
    if (atm.loggedInCustomer != null) {
      printer.printTxt('You are already logged in as ${atm.loggedInCustomer!.name}');
      printer.printSpace();
      return;
    }

    if (args.isEmpty) {
      printer.printTxt('Please input your name');
      printer.printSpace();
      return;
    }

    final name = args.join(' ');
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name) ||
        listOfNotAllowedNames.any((notAllowed) => name.contains(notAllowed)) ||
        name.contains(RegExp(r'\s{2,}'))) {
      printer.printTxt('Please enter a valid name! \x1B[1m$name\x1B[0m is not allowed');
      printer.printTxt('Only letters are allowed, any special character is prohibited');
      printer.printSpace();
      return;
    }

    atm.loggedInCustomer = atm.customers.putIfAbsent(name, () => Customer(name: name));

    printer.printTxt('Hello, $name!');
    printer.printTxt('Your balance is \$${atm.loggedInCustomer!.balance}');
    if (atm.loggedInCustomer!.owedTo.isNotEmpty) {
      final name = atm.loggedInCustomer?.owedTo.keys.first;
      final amount = atm.loggedInCustomer?.owedTo.values.first;
      printer.printTxt('Owed \$${amount} to ${name}');
    }

    if (atm.loggedInCustomer!.owedFrom.isNotEmpty) {
      final name = atm.loggedInCustomer?.owedFrom.keys.first;
      final amount = atm.loggedInCustomer?.owedFrom.values.first;
      printer.printTxt('Owed \$${amount} from ${name}');
    }
    printer.printSpace();
  }
}
