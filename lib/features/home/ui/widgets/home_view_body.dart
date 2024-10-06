import 'package:bright_white/core/helpers/customer_storage_helper.dart';
import 'package:bright_white/core/helpers/validator_utils/validator_utils.dart';
import 'package:bright_white/features/home/data/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:bright_white/core/theming/colors.dart';
import 'package:bright_white/core/theming/styles.dart';
import 'package:bright_white/generated/l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final CustomerStorageHelper _storageHelper = CustomerStorageHelper();
  List<CustomerModel> _customers = [];
  String _searchQuery = ""; // Holds the current search query
  List<CustomerModel> _filteredCustomers =
      []; // Holds the filtered list of customers

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _filteredCustomers = _customers; // Initially show all customers
  }

  Future<void> _loadCustomers() async {
    List<CustomerModel> customers = await _storageHelper.loadCustomerList();
    setState(() {
      _customers = customers;
    });
  }

  Future<void> _addCustomer() async {
    String name = '';
    String phone = '';
    String moneyText = '';
    final GlobalKey<FormState> formKey = GlobalKey();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('إضافــة عميــــل'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: ValidatorUtils.validateName,
                  decoration: const InputDecoration(
                    labelText: 'الاســــم',
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextFormField(
                  validator: ValidatorUtils.requiredField,
                  decoration: const InputDecoration(
                    labelText: 'رقــم الهاتــــف',
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    phone = value;
                  },
                ),
                TextFormField(
                  validator: ValidatorUtils.requiredField,
                  decoration: const InputDecoration(
                    labelText: 'المبـلـــــغ',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    moneyText = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text('إلغـــاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final money = int.tryParse(moneyText) ?? 0;

                  // Create the initial transaction
                  final initialTransaction = CustomerTransactions(
                    dateTime: DateTime.now(),
                    type: 'إضافة على حساب العميل',
                    amount: money,
                    description: 'تمت إضافة المعاملة الأولية عند إنشاء العميل',
                  );

                  // Create the new customer with the initial transaction
                  final newCustomer = CustomerModel(
                    name: name,
                    phone: phone,
                    money: money,
                    transactions: [
                      initialTransaction
                    ], // Add the initial transaction
                  );

                  setState(() {
                    _customers.add(newCustomer);
                  });

                  _storageHelper.saveCustomerList(_customers);

                  Navigator.of(context).pop(); // Close the dialog after saving
                }
              },
              child: const Text('إضافــة '),
            ),
          ],
        );
      },
    );

    // Reload the updated list
    _loadCustomers();
  }

  Future<void> _deleteCustomer(String phone) async {
    // Show a confirmation dialog before deleting the customer
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text(
              'هل أنت متأكد أنك تريد حذف هذا العميل؟ لا يمكن التراجع عن هذا الإجراء.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Return false if cancel is pressed
              },
              child: const Text('إلغـــاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Return true if confirm is pressed
                // Remove the customer from the main list
                setState(() {
                  _customers.removeWhere((customer) => customer.phone == phone);
                  _filteredCustomers
                      .removeWhere((customer) => customer.phone == phone);
                });

                // Save the updated customer list to SharedPreferences
                await _storageHelper.saveCustomerList(_customers);

                // Reload customers to ensure consistency
                _loadCustomers();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red color to indicate deletion
              ),
              child: const Text(
                'حذف',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTransactions(CustomerModel customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('معاملات حساب العميل ${customer.name}'),
          content: customer.transactions.isEmpty
              ? const Text("No transactions available")
              : SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: customer.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = customer.transactions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التاريــــخ: ${transaction.dateTime.toLocal().toString().split(' ')[0]}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('نوع العمليــة: ${transaction.type}'),
                            Text('قيمة العمليــة: ${transaction.amount}'),
                            if (transaction.description != null)
                              Text('الوصــــف: ${transaction.description}'),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTransaction(CustomerModel customer) async {
    String transactionAmountText = '';
    String transactionType = '+';
    String transactionDescription = '';
    final GlobalKey<FormState> formKey = GlobalKey();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('إضافة معاملة ل ${customer.name}'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: transactionType,
                  decoration: const InputDecoration(
                    labelText: 'نوع المعاملة',
                  ),
                  items: ['+', '-']
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                                type == '+' ? 'إضافة للحساب' : 'خصم من الحساب'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    transactionType = value!;
                  },
                ),
                TextFormField(
                  validator: ValidatorUtils.requiredField,
                  decoration: const InputDecoration(
                    labelText: 'قيمة المعاملة',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    transactionAmountText = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'وصف المعاملة',
                  ),
                  onChanged: (value) {
                    transactionDescription = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text('إلغـــاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final transactionAmount =
                    int.tryParse(transactionAmountText) ?? 0;

                if (formKey.currentState!.validate()) {
                  final newTransaction = CustomerTransactions(
                    dateTime: DateTime.now(),
                    type: transactionType == '+'
                        ? 'إضافة على حساب العميل'
                        : 'خصم من حساب العميل',
                    amount: transactionAmount,
                    description: transactionDescription.isNotEmpty
                        ? transactionDescription
                        : (transactionType == '+'
                            ? 'إضافة للحساب $transactionAmount'
                            : 'خصم من الحساب $transactionAmount'),
                  );

                  // Update customer's money based on the transaction type
                  setState(() {
                    if (transactionType == '+') {
                      customer.money += transactionAmount;
                    } else {
                      customer.money -= transactionAmount;
                    }
                    customer.transactions.add(newTransaction);
                  });

                  // Save the updated customer list
                  _storageHelper.saveCustomerList(_customers);

                  Navigator.of(context).pop(); // Close the dialog after saving
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );

    // Reload the updated list (not strictly necessary here, as setState already updates UI)
    _loadCustomers();
  }

  String _calculateTotalMoneyFormatted() {
    int totalMoney = 0;
    for (var customer in _customers) {
      totalMoney += customer.money;
    }

    // Format the total money using NumberFormat
    final formatter = NumberFormat('#,##0');
    return formatter.format(totalMoney);
  }

  void _filterCustomers(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredCustomers =
            _customers; // If the query is empty, show all customers
      } else {
        _filteredCustomers = _customers.where((customer) {
          return customer.name.toLowerCase().contains(query.toLowerCase()) ||
              customer.phone.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).home_lbl,
            style: Styles.bold32.copyWith(color: Colors.black),
          ),
          const Gap(48),
          SizedBox(
            width: (MediaQuery.sizeOf(context).width / 3) / 2,
            child: TextField(
              onChanged:
                  _filterCustomers, // Call the filter function on text change
              style: Styles.bold16,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xff747474),
                ),
                hintText: S.of(context).home_search,
                hintStyle: const TextStyle(color: Color(0xff747474)),
                fillColor: const Color(0xffEFEFEF),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Gap(48),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xffEFEFEF),
            ),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _addCustomer();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Set border radius to 12
                    ),
                    backgroundColor: ColorsManager.mainRed,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    S.of(context).home_newEntry,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  S.of(context).home_total(_calculateTotalMoneyFormatted()),
                  style: Styles.semiBold16.copyWith(color: Colors.black),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  S.of(context).home_name,
                  style: Styles.bold20,
                ),
                const Spacer(),
                Text(
                  S.of(context).home_phoneNum,
                  style: Styles.bold20,
                ),
                const Spacer(),
                Text(
                  S.of(context).home_money,
                  style: Styles.bold20,
                ),
                const Spacer(
                  flex: 2,
                ),
                Text(
                  S.of(context).home_actions,
                  style: Styles.bold20,
                ),
                // const Spacer(),
              ],
            ),
          ),
          Builder(builder: (BuildContext context) {
            if (_filteredCustomers.isEmpty) {
              if (_searchQuery.isEmpty) {
                if (_customers.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  return CustomersListView(
                    customers: _customers,
                    showTransactions: _showTransactions,
                    addTransaction: _addTransaction,
                    deleteCustomer: _deleteCustomer,
                  );
                }
              } else {
                return const Center(
                  child: Text("لا توجد نتائج مطابقة",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                );
              }
            } else {
              return CustomersListView(
                customers: _filteredCustomers,
                showTransactions: _showTransactions,
                addTransaction: _addTransaction,
                deleteCustomer: _deleteCustomer,
              );
            }
          })
        ],
      ),
    );
  }
}

class CustomersListView extends StatelessWidget {
  List<CustomerModel> customers;
  void Function(CustomerModel customer) showTransactions;
  void Function(CustomerModel customer) addTransaction;
  void Function(String) deleteCustomer;
  CustomersListView(
      {super.key,
      required this.customers,
      required this.showTransactions,
      required this.addTransaction,
      required this.deleteCustomer});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  customer.name,
                  style: Styles.semiBold18,
                ),
                const Spacer(),
                Text(
                  customer.phone,
                  style: Styles.semiBold18,
                ),
                const Spacer(),
                Text(
                  NumberFormat('#,##0').format(customer.money),
                  style: Styles.semiBold18,
                ),
                const Spacer(
                  flex: 2,
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        showTransactions(customer);
                      },
                      icon: const Icon(FontAwesomeIcons.list),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {
                        addTransaction(customer);
                      },
                      icon: const Icon(FontAwesomeIcons.plusMinus),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: customer.phone.length == 11 ? () {} : null,
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        color:
                            customer.phone.length == 11 ? Colors.green : null,
                      ),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {
                        deleteCustomer(customer.phone);
                      },
                      icon: const Icon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                // const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
