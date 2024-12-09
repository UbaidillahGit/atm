import '../../bin/main_atm.dart';
import '../printer/handle_print.dart';


class BalanceCommand implements Command {
  final ATM atm;
  Printer printer = ConsolePrinter();

  BalanceCommand(this.atm);

  @override
  void execute(List<String> args) {
    if (atm.loggedInCustomer == null) {
      printer.printTxt('Please login first to check balance');
      printer.printSpace();
      return;
    }
    printer.printTxt('Your balance is \$${atm.loggedInCustomer!.balance}');
    printer.printSpace();
  }
}