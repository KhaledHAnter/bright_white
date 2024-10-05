import 'dart:convert';
import 'package:bright_white/features/Auth/data/models/employ_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeStorageHelper {
  // Save the list of employees
  Future<void> saveEmployeeList(List<EmployModel> employeeList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert list of employees to JSON
    List<String> employeeListJson =
        employeeList.map((employee) => jsonEncode(employee.toJson())).toList();
    // Save to SharedPreferences
    await prefs.setStringList('employeeList', employeeListJson);
  }

  // Load the list of employees
  Future<List<EmployModel>> loadEmployeeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get list of employees in JSON form
    List<String>? employeeListJson = prefs.getStringList('employeeList');

    if (employeeListJson != null) {
      return employeeListJson.map((employeeJson) {
        Map<String, dynamic> json = jsonDecode(employeeJson);
        return EmployModel.fromJson(json);
      }).toList();
    } else {
      // Return empty list if no data found
      return [];
    }
  }

  // Delete a specific employee by their code
  Future<void> deleteEmployeeByCode(String code) async {
    List<EmployModel> employeeList = await loadEmployeeList();
    // Filter out the employee with the specified code
    employeeList.removeWhere((employee) => employee.code == code);
    // Save the updated list back to SharedPreferences
    await saveEmployeeList(employeeList);
  }
}
