import 'package:bright_white/core/theming/styles.dart';
import 'package:bright_white/features/home/data/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

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
