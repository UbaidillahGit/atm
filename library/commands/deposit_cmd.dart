import '../../bin/main_atm.dart';
import '../printer/handle_print.dart';


/// DepositCommand class handle deposit operations in the ATM system.
/// 
/// This command allows a logged-in customer to deposit an amount into their account.
/// If the customer owes money to another customer, the deposit will first settle the debt.
/// 
/// The command expects a single argument which is the deposit amount.
/// 
/// If the customer is not logged in, or if the deposit amount is invalid, appropriate messages will be printed.
/// 
class DepositCommand extends Command {
  final ATM atm;

  Printer printer = ConsolePrinter();

  DepositCommand(this.atm);

  @override
  void execute(List<String> args) {
    if (atm.loggedInCustomer == null) {
      printer.printTxt('Please login first to deposit');
      printer.printSpace();
      return;
    }

    if (args.isEmpty) {
      printer.printTxt('Please input your deposit amount');
      return;
    }

    try {
      final hasOwedTo = atm.loggedInCustomer?.owedTo;
      final amount = int.parse(args[0]);

      if (hasOwedTo!.isNotEmpty) {
        final targetName = hasOwedTo.keys.first;
        atm.loggedInCustomer?.settleDebtAndDeposit(customer: atm.customers[targetName]!, amount: amount);
      } else {
        atm.loggedInCustomer?.deposit(amount);
      }
    } catch (e) {
      printer.printTxt('Please input a valid number for the deposit amount');
    }
  }
}