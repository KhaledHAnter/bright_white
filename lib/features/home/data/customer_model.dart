import 'dart:convert';

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

  // Convert CustomerModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'money': money,
      'transactions':
          transactions.map((transaction) => transaction.toJson()).toList(),
    };
  }

  // Convert JSON to CustomerModel
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name'],
      phone: json['phone'],
      money: json['money'],
      transactions: (json['transactions'] as List)
          .map((transactionJson) =>
              CustomerTransactions.fromJson(transactionJson))
          .toList(),
    );
  }
}

class CustomerTransactions {
  final DateTime dateTime;
  final String type;
  final int amount;
  final String? description;

  CustomerTransactions({
    required this.dateTime,
    required this.type,
    required this.amount,
    this.description,
  });

  // Convert CustomerTransactions to JSON
  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'type': type,
      'amount': amount,
      'description': description,
    };
  }

  // Convert JSON to CustomerTransactions
  factory CustomerTransactions.fromJson(Map<String, dynamic> json) {
    return CustomerTransactions(
      dateTime: DateTime.parse(json['dateTime']),
      type: json['type'],
      amount: json['amount'],
      description: json['description'],
    );
  }
}
