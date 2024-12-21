import 'dart:io';

void main(List<String> args) {
  while (true) {
    var bankAccount = initBankAccount();

    while (true) {
      var transactionType = enterSingleCharacter(
          "Enter transaction type (i for information / w for withdraw / d for deposit / c for close)",
          "iIwWdDcC");

      switch (transactionType) {
        case 'i':
        case 'I':
          bankAccount.displayAccountInfo();
          continue;

        case 'w':
        case 'W':
          var amount = enterDouble("Enter amount to withdraw:");

          bankAccount.withdraw(amount);

          continue;

        case 'd':
        case 'D':
          var amount = enterDouble("Enter amount to deposit:");

          bankAccount.deposit(amount);

          continue;

        case 'c':
        case 'C':
          break;
      }

      break;
    }

    var openAnotherAccount =
        enterSingleCharacter("Open another account? (y/n)", 'yYnN');

    switch (openAnotherAccount) {
      case 'y':
      case 'Y':
        continue;

      case 'n':
      case 'N':
      default:
        break;
    }

    break;
  }
}

/// @brief Initializes a bank account based on user input.
BankAccount initBankAccount() {
  print("Enter account ID:");

  String accountId = stdin.readLineSync() ?? "";

  String isZeroBalance =
      enterSingleCharacter("Zero-balance account? (y/n)", "yYnN");

  BankAccount bankAccount;

  switch (isZeroBalance) {
    case 'y':
    case 'Y':
      bankAccount = BankAccount.zeroBalanceAccount(accountId);
      break;

    case 'n':
    case 'N':
    default:
      double balance = enterDouble("Enter balance:");

      bankAccount = BankAccount(accountId, balance);

      break;
  }

  return bankAccount;
}

/// @brief Prompts the user to enter a single character from a set of valid characters.
String enterSingleCharacter(String prompt, String validCharacters) {
  while (true) {
    print(prompt);

    String response = stdin.readLineSync() ?? "";

    bool valid = response.length == 1 && validCharacters.contains(response);

    if (valid) {
      return response;
    }

    print("invalid input");
  }
}

/// @brief Prompts the user to enter a double value.
double enterDouble(String prompt) {
  while (true) {
    try {
      print(prompt);
      return double.parse(stdin.readLineSync() ?? "");
    } catch (e) {
      print("invalid input");
      continue;
    }
  }
}

/// @class BankAccount
/// @brief A class representing a bank account with basic operations.
class BankAccount {
  String _accountId;
  double _balance;

  /// @brief Constructor to create a bank account with a specified balance.
  /// @param accountId The ID of the bank account.
  /// @param balance The initial balance of the bank account.
  BankAccount(this._accountId, this._balance);

  /// @brief Constructor to create a zero-balance bank account.
  /// @param accountId The ID of the bank account.
  BankAccount.zeroBalanceAccount(this._accountId) : this._balance = 0.0;

  /// @brief Withdraws a specified amount from the bank account.
  /// @param amount The amount to withdraw.
  /// @note Prints an error message if the amount is negative or exceeds the current balance.
  void withdraw(double amount) {
    // Check if the amount is negative
    if (amount < 0.0) {
      print("invalid withdrawal amount: amount may not be negative!");
      return;
    }

    // Check if the amount exceeds the current balance
    if (amount > _balance) {
      print("could not withdraw requested amount: balance too low!");
      return;
    }

    // Perform the withdrawal
    _balance -= amount;
    print("successfully withdrawn ${amount}; current balance is ${_balance}");
  }

  /// @brief Deposits a specified amount into the bank account.
  /// @param amount The amount to deposit.
  /// @note Prints an error message if the amount is negative.
  void deposit(double amount) {
    // Check if the amount is negative
    if (amount < 0.0) {
      print("invalid deposition amount: amount may not be negative!");
      return;
    }

    // Perform the deposit
    _balance += amount;
    print("successfully deposited ${amount}; current balance is ${_balance}");
  }

  /// @brief Displays the account information.
  void displayAccountInfo() {
    print("*** Bank Account Info ***");
    print("Account ID: ${_accountId}");
    print("Account Balance: ${_balance}");
    print("*************************");
  }
}
