import '../../bin/main_atm.dart';
import '../customer_model.dart';
import '../printer/handle_print.dart';

/// TransferCommand class handle money transfers between customers in an ATM system.
///
/// This command checks if the user is logged in, validates the input, and ensures
/// that the user is not transferring money to themselves or while having unsettled debts.
///
/// The command expects the recipient's name and the transfer amount as arguments.
///
/// If the input is invalid or the transfer is not allowed, appropriate messages are printed.
///
/// Implements the [Command] interface.
///
class TransferCommand implements Command {
  final ATM atm;
  Printer printer = ConsolePrinter();

  TransferCommand(this.atm);

  List<String> getCharactersWithoutExtraWhiteSpace(String input) {
    return input.split(RegExp(r'\s+')).where((element) => element.isNotEmpty).toList();
  }

  @override
  void execute(List<String> args) {
    if (atm.loggedInCustomer == null) {
      printer.printTxt('Please login first to transfer');
      printer.printSpace();
      return;
    }

    if (args.length < 2 || args.length > 2) {
      printer.printTxt('Please input correct transfer command e.g. "transfer Elon 50".');
      printer.printSpace();
      return;
    }

    try {
      final amount = int.parse(args.last);
      final recipient = args.sublist(0, args.length - 1).join(' ');

      // Handle when user transfer to the same name of logged in user
      if (recipient.isNotEmpty && recipient == atm.loggedInCustomer?.name) {
        printer.printTxt('You cannot transfer to yourself');
        printer.printSpace();
        return;
      } else if (recipient.isEmpty || recipient.contains(RegExp(r'\d'))) {
        printer.printTxt('Please input a correct name (any numeric or whitespace on name is prohibited).');
        printer.printSpace();
        return;
      }
      final target = atm.customers.putIfAbsent(recipient, () => Customer(name: recipient));

      // Ensure current Customer has only singe [owedTo],
      // current customer unable transfer to any other customer, before their current owed not settled yet
      final hasAnyOwedTo = atm.loggedInCustomer?.owedTo.isNotEmpty;
      if (hasAnyOwedTo == true) {
        final custNameOfOwedTo = atm.loggedInCustomer?.owedTo.keys.first;
        printer.printTxt('Not allowed transfer to other!');
        printer.printTxt('You need to settled the owed to $custNameOfOwedTo first');
        printer.printSpace();
        return;
      } else {
        atm.loggedInCustomer?.transfer(target, amount);
      }
    } on FormatException catch (e) {
      if (e.message == 'Invalid radix-10 number' || e.message == 'Invalid number') {
        printer.printTxt('Please input correct transfer command e.g. "transfer Elon 50".');
        printer.printSpace();
      }
      printer.printSpace();
    } on RangeError catch (e) {
      printer.printTxt('RangeError $e');
      printer.printSpace();
    }
  }
}
