import '../../bin/main_atm.dart';
import '../printer/handle_print.dart';


class LogoutCommand implements Command {
  final ATM atm;
  Printer printer = ConsolePrinter();

  LogoutCommand(this.atm);

  @override
  void execute(List<String> args) {
    if (atm.loggedInCustomer == null) {
      printer.printTxt('You are not logged in to any account');
      printer.printSpace();
      return;
    }

    printer.printTxt('Goodbye, ${atm.loggedInCustomer?.name}');
    printer.printTxt('');
    atm.loggedInCustomer = null;
  }
}