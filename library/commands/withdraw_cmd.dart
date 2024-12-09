import '../../bin/main_atm.dart';
import '../printer/handle_print.dart';


/// WithdrawCommand class handle the withdrawal process from an ATM.
///
/// This command checks if a customer is logged in, validates the withdrawal amount,
/// and performs the withdrawal operation.
///
/// If the customer is not logged in, or if the withdrawal amount is invalid,
/// appropriate error messages will be printed.
/// 
class WithdrawCommand extends Command {
  final ATM atm;
  Printer printer = ConsolePrinter();
  WithdrawCommand(this.atm);

  @override
  void execute(List<String> args) {
    if (atm.loggedInCustomer == null) {
      printer.printTxt('Please login first to withdraw');
      printer.printSpace();
      return;
    }

    if (args.isEmpty) {
      printer.printTxt('Please input your withdraw amount');
      printer.printSpace();
      return;
    }

    try {
      final amount = int.parse(args[0]);
      atm.loggedInCustomer?.withdraw(amount);
    } catch (e) {
      printer.printTxt('Please input a valid number for the withdraw amount');
      printer.printSpace();
    }
  }
}