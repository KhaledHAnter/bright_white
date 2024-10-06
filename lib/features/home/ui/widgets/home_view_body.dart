import 'package:bright_white/core/helpers/customer_storage_helper.dart';
import 'package:bright_white/core/helpers/validator_utils/validator_utils.dart';
import 'package:bright_white/features/home/data/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:bright_white/core/theming/colors.dart';
import 'package:bright_white/core/theming/styles.dart';
import 'package:bright_white/generated/l10n.dart';
// import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

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
                  autofocus: true,
                  validator: ValidatorUtils.validateName,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'الاســــم',
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextFormField(
                  validator: ValidatorUtils.requiredField,
                  textInputAction: TextInputAction.next,
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

  Future<void> _deleteCustomer(CustomerModel customer) async {
    String confirmationName = '';

    // Show a confirmation dialog before deleting the customer
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('تأكيد الحذف'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'هل أنت متأكد أنك تريد حذف هذا العميل؟ لا يمكن التراجع عن هذا الإجراء.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'اكتب اسم العميل للتأكيد',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        confirmationName = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cancel deletion
                  },
                  child: const Text('إلغـــاء'),
                ),
                ElevatedButton(
                  onPressed: confirmationName == customer.name
                      ? () async {
                          Navigator.of(context).pop(true);
                          setState(() {
                            _customers
                                .removeWhere((c) => c.phone == customer.phone);
                            _filteredCustomers
                                .removeWhere((c) => c.phone == customer.phone);
                          });

                          // Save the updated customer list to SharedPreferences
                          await _storageHelper.saveCustomerList(_customers);

                          // Reload customers to ensure consistency
                          _loadCustomers(); // Confirm deletion
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Red color to indicate deletion
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
      },
    );

    // If the user confirms the deletion, proceed to delete the customer
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
                  autofocus: true,
                  textInputAction: TextInputAction.next,
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

  Future<void> _editCustomerPhoneNumber(CustomerModel customer) async {
    String updatedPhone = customer.phone;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تعديل رقم الهاتف ل ${customer.name}'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  initialValue: customer.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف الجديد',
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    updatedPhone = value;
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
                if (updatedPhone.isNotEmpty) {
                  setState(() {
                    customer.phone = updatedPhone;
                  });

                  _storageHelper.saveCustomerList(_customers);
                }

                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );

    // Reload the updated list to ensure consistency
    _loadCustomers();
  }

  Future<void> _generatePdf() async {
    // Load the Arabic font from assets
    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final pdf = pw.Document();

    // Add content to the PDF using MultiPage to accommodate multiple pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text(
                        'قائمة العملاء',
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Spacer(),
                      pw.Text(
                        'التاريخ : $date',
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Spacer(),
                      pw.Text(
                        ' المجموع : ${_calculateTotalMoneyFormatted()}',
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 18,
                            color: PdfColor.fromHex('#8B0000'),
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 16),
                  // Iterate over all customers and add their details to the PDF
                  for (var customer in _customers) ...[
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'الاسم: ${customer.name}',
                          style: pw.TextStyle(font: ttf, fontSize: 14),
                        ),
                        pw.Text(
                          'الهاتف: ${customer.phone}',
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                        ),
                        pw.Text(
                          'المبلغ المستحق: ${NumberFormat('#,##0').format(customer.money)}',
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#06402B'),
                          ),
                        ),
                      ],
                    ),
                    if (customer.transactions.isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Align(
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          'المعاملات:',
                          style: pw.TextStyle(
                              font: ttf,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          for (var transaction in customer.transactions) ...[
                            pw.Text(
                              '- التاريخ: ${transaction.dateTime.toLocal().toString().split(' ')[0]},         النوع: ${transaction.type},         المبلغ: ${NumberFormat('#,##0').format(transaction.amount)}         الوصف: ${transaction.description ?? 'N/A'}',
                              style: pw.TextStyle(font: ttf, fontSize: 10),
                            ),
                          ],
                        ],
                      ),
                    ],
                    pw.SizedBox(height: 12), // Add space between customers
                    pw.Divider(),
                  ],
                ],
              ),
            ),
          ];
        },
      ),
    );

    // Get the directory to save the PDF and create a 'PDFs' folder if it doesn't exist
    final outputDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${outputDir.path}/PDFs');

    if (!await pdfDir.exists()) {
      await pdfDir.create(
          recursive: true); // Create the directory if it doesn't exist
    }

    // Create a file name with the current date
    final fileName = 'Customer_List_$date.pdf';

    // Save the PDF in the 'PDFs' directory
    final file = File('${pdfDir.path}/$fileName');

    // Write the PDF content to the file
    await file.writeAsBytes(await pdf.save());

    // Inform the user that the PDF has been saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ ملف PDF في ${file.path}')),
    );
  }

  Future<void> _sendWhatsAppMessage(CustomerModel customer) async {
    String phone = customer.phone;
    String message =
        "مرحبًا ,نرجو منك سداد المبلغ المستحق وقدره ${"${NumberFormat('#,##0').format(customer.money)} ج.م "}في أقرب وقت.\nشكرًا لك.";

    // Construct the WhatsApp URL
    String url = "https://wa.me/+2$phone?text=${Uri.encodeComponent(message)}";

    // Check if the URL can be launched (i.e., WhatsApp is installed)
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Show an error message if WhatsApp is not installed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp غير مثبت على هذا الجهاز')),
      );
    }
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
                ),
                const Gap(40),
                IconButton(
                    onPressed: () {
                      _generatePdf();
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded)),
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
                    editCustomerPhoneNumber: _editCustomerPhoneNumber,
                    sendWhatsAppMessage: _sendWhatsAppMessage,
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
                editCustomerPhoneNumber: _editCustomerPhoneNumber,
                sendWhatsAppMessage: _sendWhatsAppMessage,
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
  void Function(CustomerModel customer) editCustomerPhoneNumber;
  void Function(CustomerModel customer) deleteCustomer;
  void Function(CustomerModel customer) sendWhatsAppMessage;
  CustomersListView({
    super.key,
    required this.customers,
    required this.showTransactions,
    required this.addTransaction,
    required this.deleteCustomer,
    required this.editCustomerPhoneNumber,
    required this.sendWhatsAppMessage,
  });

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
                  "${NumberFormat('#,##0').format(customer.money)} ج.م",
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
                      onPressed: customer.phone.length == 11
                          ? () {
                              sendWhatsAppMessage(customer);
                            }
                          : null,
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        color:
                            customer.phone.length == 11 ? Colors.green : null,
                      ),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {
                        editCustomerPhoneNumber(customer);
                      },
                      icon: const Icon(
                        FontAwesomeIcons.pen,
                      ),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {
                        deleteCustomer(customer);
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
