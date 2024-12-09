
// List of command based on attached example case
final automatedCommands = [
  'login Alice',
  'deposit 100',
  'logout',
  'login Bob',
  'deposit 80',
  'transfer Alice 50',
  'transfer Alice 100',
  'deposit 30',
  'logout',
  'login Alice',
  'transfer Bob 30',
  'logout',
  'login Bob',
  'deposit 100',
  'logout'
];

// List of command based on attached example case
final automatedCommands2 = [
  'login Alice',
  'transfer Bob 20',
  'logout',
  'login Bob',
  'transfer Alice 20',
  'logout',
  'login Alice',
];

// Cases where current customer does not have balance and transfer to target
final automatedCommands3 = [
  'login Alice',
  'transfer Bob 20',
  'logout',
  'login Bob',
  'transfer Alice 10',
  'transfer Alice 10',
  'logout',
  'login Alice',
  'logout',
  'login Alice'
];

// Cases when user has and owed to a singgle customer, and want to transfer to other customer
final automatedCommands4 = [
  'login Alice',
  'transfer Bob 20',
  'transfer Elon 20',
  'logout',
  'login Bob',
  'transfer Alice 10',
  'transfer Alice 30',
  'logout',
  'login Alice',
  'logout',
  'login Alice'
];
