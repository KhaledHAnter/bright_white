class CustomerModel {
  String name;
  String phone;
  int money;
  List<CustomerTransactions> transactions;

  CustomerModel({
    required this.name,
    required this.phone,
    required this.money,
    required this.transactions,
  });
}

class CustomerTransactions {
  final DateTime dateTime;
  final String type;
  final int amount;
  final String? description;

  CustomerTransactions(
      {required this.dateTime,
      required this.type,
      required this.amount,
      this.description});
}
