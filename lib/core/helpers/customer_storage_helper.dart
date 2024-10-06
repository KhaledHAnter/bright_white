import 'dart:convert';
import 'package:bright_white/features/home/data/customer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerStorageHelper {
  // Save the list of customers
  Future<void> saveCustomerList(List<CustomerModel> customerList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert list of customers to JSON strings
    List<String> customerListJson =
        customerList.map((customer) => jsonEncode(customer.toJson())).toList();
    // Save to SharedPreferences
    await prefs.setStringList('customerList', customerListJson);
  }

  // Load the list of customers
  Future<List<CustomerModel>> loadCustomerList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? customerListJson = prefs.getStringList('customerList');

    if (customerListJson != null) {
      return customerListJson.map((customerJson) {
        Map<String, dynamic> json = jsonDecode(customerJson);
        return CustomerModel.fromJson(json);
      }).toList();
    } else {
      // Return empty list if no data found
      return [];
    }
  }

  // Delete a customer by their phone number
  Future<void> deleteCustomerByPhone(String phone) async {
    List<CustomerModel> customerList = await loadCustomerList();
    // Filter out the customer with the specified phone number
    customerList.removeWhere((customer) => customer.phone == phone);
    // Save the updated list back to SharedPreferences
    await saveCustomerList(customerList);
  }
}
