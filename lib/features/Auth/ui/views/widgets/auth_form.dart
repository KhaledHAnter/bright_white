import 'package:bright_white/core/helpers/employee_storage_helper.dart';
import 'package:bright_white/core/helpers/extentions.dart';
import 'package:bright_white/core/routing/routes.dart';
import 'package:bright_white/core/widgets/app_button.dart';
import 'package:bright_white/features/Auth/data/models/employ_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AuthForm extends StatelessWidget {
  AuthForm({super.key});
  final List<EmployModel> employeeList = [
    const EmployModel(
      name: 'Mohamed Anter',
      code: '922002',
      role: 'Manager',
    ),
    const EmployModel(
      name: 'Mahmoud El-Morsy',
      code: '205080',
      role: 'Employee',
    ),
  ];

  late String otpCode;

  Future<bool> _checkEmployeeCode(String code) async {
    EmployeeStorageHelper hlper = EmployeeStorageHelper();
    List<EmployModel>? employeeList = await hlper.loadEmployeeList();

    if (employeeList.isNotEmpty) {
      // Check if any employee has the matching code
      for (var employee in employeeList) {
        if (employee.code == code) {
          return true;
        }
      }
    }

    return false;
  }

  void navigationOptions(BuildContext context) async {
    if (otpCode.isNotEmpty) {
      bool isCodeValid = await _checkEmployeeCode(otpCode);
      if (isCodeValid) {
        // If valid, perform some action
        context.pushReplacementNamed(Routes.homeView);
      } else {
        // If not valid, show an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Invalid employee code. Please try again.',
                style: TextStyle(fontSize: 18, color: Colors.white),
              )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text(
          "Nice to see you again",
          style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w600), // Replace Styles.semiBold18 with TextStyle
          textAlign: TextAlign.start,
        ),
        const Gap(24),
        _buildPinCodeField(context),
        const Gap(24),
        AppButton(
          text: "Continue",
          onTap: () {
            navigationOptions(context);
          },
        ),
      ],
    );
  }

  Widget _buildPinCodeField(BuildContext context) {
    int pinLength = 6;
    double pinWidth =
        (MediaQuery.sizeOf(context).width / 3) / (pinLength + 1) - pinLength;
    return PinCodeTextField(
      appContext: context,
      autoFocus: true,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      length: pinLength,
      obscureText: true,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 70,
        fieldWidth: pinWidth,
        borderWidth: 1,
        activeColor:
            Colors.blue, // Replace with ColorsManager.blue if you have it
        inactiveColor: Colors.blue,
        inactiveFillColor: Colors.white,
        activeFillColor:
            Colors.lightBlue, // Replace with ColorsManager.lightBlue if needed
        selectedColor: Colors.blue,
        selectedFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      enableActiveFill: true,
      onCompleted: (code) {
        otpCode = code;
        navigationOptions(context);
      },
    );
  }
}
