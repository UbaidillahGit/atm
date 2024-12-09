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

  @override
  void execute(List<String> args) {
    if (atm.loggedInCustomer == null) {
      printer.printTxt('Please login first to transfer');
      printer.printSpace();
      return;
    }

    /// Handle input nominal validation
    ///  
    if (args.length < 2) {
      printer.printTxt('Please input nominal to transfer after name. e.g. transfer Elon 50');
      printer.printSpace();
      return;
    }

    /// Handle when user transfer to the same name of logged in user
    ///  
    final recipient = args.sublist(0, args.length - 1).join(' ');
    if (recipient == atm.loggedInCustomer?.name) {
      printer.printTxt('You cannot transfer to yourself');
      printer.printSpace();
      return;
    }

    try {
      final amount = int.parse(args.last);
      final target = atm.customers.putIfAbsent(recipient, () => Customer(name: recipient));

      /// Ensure current Customer has only singe [owedTo],
      /// current customer unable transfer to any other customer, before their current owed not settled yet
      ///
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
    } catch (e) {
      print('catch $e');
      printer.printTxt('Please input a valid number for the transfer amount');
      printer.printTxt('Only integers are allowed');
      printer.printSpace();
    }
  }
}
