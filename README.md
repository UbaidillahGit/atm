# ATM CLI Application
This is a command-line interface (CLI) application for simulating an ATM system. The application supports both automated and manual modes for executing commands.

# Prerequisites
Dart SDK installed and available in the system's PATH.

# Commands
The following commands are supported:

- login <customerName>: Log in as a customer.
- deposit <amount>: Deposit a specified amount.
- withdraw <amount>: Withdraw a specified amount.
- transfer <customerName> <amount>: Transfer a specified amount to another customer.
- logout: Log out the current customer.
- balance: Check the current balance.
- exit: Exit the application.

# Example automated commands
List of automated commands can be found at library/list_of_automated_cmd.dart

## Project Structure
atm_simulation/
├── bin/
│   └── main_atm.dart
├── lib/
│   ├── commands/
│   │   ├── balance_cmd.dart
│   │   ├── deposit_cmd.dart
│   │   ├── invalid_cmd.dart
│   │   ├── login_cmd.dart
│   │   ├── logout_cmd.dart
│   │   ├── transfer_cmd.dart
│   │   └── withdraw_cmd.dart
│   ├── customer_model.dart
│   └── printer/
│       └── handle_print.dart
├── test/
│   └── atm_test.dart
├── pubspec.yaml
├── pubspec.lock
├── start.sh
└── README.md