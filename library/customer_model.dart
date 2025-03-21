import 'printer/handle_print.dart';

/// `Customer` class represents a customer with a name, balance, and records of debts owed to and from other customers.
/// It provides methods to deposit, withdraw, transfer money, and handle debts.
///
/// Properties:
/// - `name`: The name of the customer.
/// - `balance`: The current balance of the customer.
/// - `owedTo`: A map of customers to whom this customer owes money.
/// - `owedFrom`: A map of customers who owe money to this customer.
/// - `printer`: An instance of `Printer` used for printing messages.
///
/// Methods:
/// - `Customer({required this.name})`: Constructor to create a customer with a given name.
/// - `void deposit(int amount)`: Deposits the specified amount to the customer's balance.
/// - `void withdraw(int amount)`: Withdraws the specified amount from the customer's balance if sufficient funds are available.
/// - `void settleDebtAndDeposit({required Customer customer, required int amount})`: Settles debt with another customer and deposits any remaining amount.
/// - `void transfer(Customer customer, int amount)`: Transfers the specified amount to another customer, handling different balance scenarios.
/// - `void _handleSufficientBalanceTransfer(Customer customer, int amount)`: Handles the transfer when the current customer has sufficient balance.
/// - `void _handleInsufficientBalanceTransfer(Customer customer, int amount)`: Handles the transfer when the current customer has insufficient balance.
/// - `void _handleNoBalanceTransfer(Customer customer, int amount)`: Handles the transfer when the current customer has no balance.
/// Handle [deposit], [withdraw], [transfer] within this model
///

class Customer {
  String name;
  int balance = 0;
  Map<String, int> owedTo = {};
  Map<String, int> owedFrom = {};
  Printer printer = ConsolePrinter();

  Customer({required this.name});

  void deposit(int amount) {
    balance += amount;
    printer.printBalance(balance);
    printer.printSpace();
  }

  void withdraw(int amount) {
    if (balance >= amount) {
      balance -= amount;
      printer.printBalance(balance);
      printer.printSpace();
    } else {
      printer.printInsufficientBalance();
      printer.printSpace();
    }
  }

  void settleDebtAndDeposit({required Customer customer, required int amount}) {
    final amountOfOwedTo = owedTo.values.first;
    final remainingAmount = (amount - amountOfOwedTo);

    // If after transfer the amount still remaining, then deposit it to Current customer as balance
    //
    if (remainingAmount <= 0) {
      customer.balance += amount;
      owedTo[customer.name] = amount;
      customer.owedFrom = {name: remainingAmount.abs()};
      printer.printTransfer(amount, customer.name);
      printer.printBalance(balance);
      printer.printOwedTo(customer.name, remainingAmount.abs());
      printer.printSpace();
    } else if (remainingAmount > 0) {
      balance += remainingAmount.abs();
      printer.printTransfer(amountOfOwedTo, customer.name);
      printer.printBalance(balance);
      printer.printSpace();
      owedTo.remove(customer.name);
    }
  }

  void transfer(Customer customer, int amount) {
    if (amount <= 0) {
      printer.printTxt('Please input a valid number for the transfer amount');
      return;
    }


    // Seperate the transfer case with these condition
    //
    final sufficientBalance = (balance >= amount);
    final insufficientBalance = (balance <= amount && balance != 0);
    final noBalance = (balance == 0);

    print('test_fired ${customer.name} | $amount | $sufficientBalance');
    if (sufficientBalance) {
      _handleSufficientBalanceTransfer(customer, amount);
    } else if (insufficientBalance) {
      _handleInsufficientBalanceTransfer(customer, amount);
    } else if (noBalance) {
      _handleNoBalanceTransfer(customer, amount);
    }
  }

  void _handleSufficientBalanceTransfer(Customer customer, int amount) {
    if (owedFrom.containsKey(customer.name)) {
      final remainingAmountAfterTransfer = (owedFrom.values.first - amount);
      if (remainingAmountAfterTransfer >= 0) {
    // print('_handleSufficientBalanceTransfer_fired');
        owedFrom = {name: remainingAmountAfterTransfer};
        customer.owedTo = {name: remainingAmountAfterTransfer};
        printer.printBalance(balance);
        printer.printOwedFrom(customer.name, remainingAmountAfterTransfer);
        printer.printSpace();
      } else {
        // Handle case when current Customer transfer to target Customer and have more amount than needed.
        // Reduce [owedFrom] amount to target first, that add
        customer.owedTo.clear();
        customer.balance += remainingAmountAfterTransfer.abs();
        balance -= remainingAmountAfterTransfer.abs();
        printer.printTransfer(remainingAmountAfterTransfer.abs(), customer.name);
        printer.printBalance(balance);
        printer.printOwedFrom(customer.name, 0);
        printer.printSpace();
      }
    } else {
      balance -= amount;
      customer.balance += amount;
      printer.printTransfer(amount, customer.name);
      printer.printBalance(balance);
      printer.printSpace();
    }
  }

  /// Handle transfer with no balance, the method more handling on [OwedTo] and [OwedFrom] change
  void _handleInsufficientBalanceTransfer(Customer customer, int amount) {
    final amountOfOwedToTarget = (amount - balance);
    final amountAbleToTransfer = balance;
    customer.balance += balance;
    balance = 0;
    owedTo[customer.name] = amountOfOwedToTarget;
    customer.owedFrom = {name: amountOfOwedToTarget};
    print('_handleInsufficientBalanceTransfer_fired | $amountAbleToTransfer | ${customer.name}');
    printer.printTransfer(amountAbleToTransfer, customer.name);
    printer.printBalance(balance);
    printer.printOwedTo(customer.name, amountOfOwedToTarget);
    printer.printSpace();
  }

  void _handleNoBalanceTransfer(Customer customer, int amount) {

    if (owedFrom.containsKey(customer.name)) {

      // Calculation
      int? amountOfOwedFrom = owedFrom[customer.name]!;
      int? amountOfOwedTo = customer.owedTo[name]!;

      // OwedFrom operation
      amountOfOwedFrom -= amount;
      owedFrom = {customer.name: amountOfOwedFrom};
      
      // OwedTo operation
      amountOfOwedTo -= amount;
      if (amountOfOwedTo == 0) {
        customer.owedTo.clear();
      } else {
        customer.owedTo[name] = amountOfOwedTo;
      }

      // Print section
      printer.printTransfer(amount, customer.name);
      printer.printBalance(balance);
      printer.printOwedFrom(customer.name, owedFrom.values.first);
    } else {
      owedTo = {customer.name: amount};
      customer.owedFrom = {name: amount};
      printer.printTransfer(amount, customer.name);
      printer.printBalance(balance);
      printer.printOwedTo(customer.name, amount);
    }
    printer.printSpace();
  }
}
