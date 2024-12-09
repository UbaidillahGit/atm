import 'dart:io';

import '../library/commands/balance_cmd.dart';
import '../library/commands/deposit_cmd.dart';
import '../library/commands/invalid_cmd.dart';
import '../library/commands/login_cmd.dart';
import '../library/commands/logout_cmd.dart';
import '../library/commands/transfer_cmd.dart';
import '../library/commands/withdraw_cmd.dart';
import '../library/customer_model.dart';
import '../library/printer/handle_print.dart';
import '../library/list_of_automated_cmd.dart';


/// Main entry point of the ATM application.
/// 
/// This function initializes an instance of the [ATM] class and ensures that
/// the data directory exists by creating it if it does not. It then runs the
/// ATM application using automated commands for testing or demonstration
/// purposes. 
/// 
/// To run the ATM application with manual input, uncomment the
/// `atm.run()` line and comment out the `atm.runAutomated(automatedCommands)`
/// line.
/// 
void main() {
  final atm = ATM();
  // Ensure the data directory exists
  Directory('data').createSync();
  
  /// Open [runAutomated] to run CLI with automated commands
  /// Open [run] to run the CLI with manual input
  /// 
  // atm.runAutomated(automatedCommands);
  atm.run();
}

/// [ATM] class represents an Automated Teller Machine (ATM) system.
/// It manages customers, handles user commands, and interacts with a printer
/// to display messages.
///
/// Properties:
/// - `customers`: A map of customer IDs to `Customer` objects.
/// - `loggedInCustomer`: The currently logged-in customer, if any.
/// - `printer`: An instance of `Printer` used to print messages.
///
/// Methods:
/// - `run()`: Starts the ATM CLI, continuously reading and handling user input
///   until the user exits.
/// - `runAutomated(List<String> commands)`: Executes a list of commands
///   automatically, useful for testing or scripting.
/// - `handleCommand(String input)`: Parses and executes a user command.
/// 
class ATM {
  final Map<String, Customer> customers = {};
  Customer? loggedInCustomer;
  Printer printer = ConsolePrinter();

  void run() {
    printer.printTxt('Welcome to the ATM CLI!');
    printer.printSpace();
    while (true) {
      stdout.write('\$ ');
      final input = stdin.readLineSync();
      if (input == null || input.toLowerCase() == 'exit') break;
      handleCommand(input);
    }
  }

  void runAutomated(List<String> commands) {
    for (final command in commands) {
      printer.printTxt('\$ $command');
      handleCommand(command);
    }
  }

  void handleCommand(String input) {
    final userInput = input.split(' ');
    final command = userInput[0].toLowerCase();
    final args = userInput.sublist(1);

    final commandHandler = CommandFactory.getCommand(command, this);
    if (commandHandler != null) {
      try {
        commandHandler.execute(args);
      } catch (e) {
        printer.printTxt('Error: ${e.toString()}');
      }
    } else {
      printer.printTxt('Please input a Command');
    }
  }
}

/// An abstract class representing a command that can be executed with a list of arguments.
/// 
/// Classes that implement this abstract class should provide an implementation for the [execute] method.
/// 
/// The [execute] method takes a list of strings as arguments and performs the command's action.
/// 
abstract class Command {
  void execute(List<String> args);
}

/// A factory class to create instances of different ATM commands based on the input string.
/// 
/// The `CommandFactory` class provides a static method `getCommand` which takes a command string
/// and an instance of `ATM`, and returns an appropriate command object.
/// 
/// Supported commands:
/// - 'login': Returns an instance of `LoginCommand`.
/// - 'deposit': Returns an instance of `DepositCommand`.
/// - 'withdraw': Returns an instance of `WithdrawCommand`.
/// - 'transfer': Returns an instance of `TransferCommand`.
/// - 'logout': Returns an instance of `LogoutCommand`.
/// - 'balance': Returns an instance of `BalanceCommand`.
/// - Any other command: Returns an instance of `InvalidCommand`.
/// 
class CommandFactory {
  static Command? getCommand(String command, ATM atm) {
    switch (command) {
      case 'login':
        return LoginCommand(atm);
      case 'deposit':
        return DepositCommand(atm);
      case 'withdraw':
        return WithdrawCommand(atm);
      case 'transfer':
        return TransferCommand(atm);
      case 'logout':
        return LogoutCommand(atm);
      case 'balance':
        return BalanceCommand(atm);
      default:
        return InvalidCommand();
    }
  }
}
