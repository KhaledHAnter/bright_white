class EmployModel {
  final String name;
  final String code;
  final String role;

  const EmployModel({
    required this.name,
    required this.code,
    required this.role,
  });

  // Convert EmployModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'role': role,
    };
  }

  // Convert JSON to EmployModel
  factory EmployModel.fromJson(Map<String, dynamic> json) {
    return EmployModel(
      name: json['name'],
      code: json['code'],
      role: json['role'],
    );
  }
}
