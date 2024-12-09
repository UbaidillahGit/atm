import '../../bin/main_atm.dart';
import '../printer/handle_print.dart';


class InvalidCommand implements Command {

  Printer printer = ConsolePrinter();
  InvalidCommand();
  
  @override
  void execute(List<String> args) {
    printer.printTxt('Please input a valid Command');
    printer.printSpace();
  }
}