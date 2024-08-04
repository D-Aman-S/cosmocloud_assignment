import 'dart:convert';
import 'package:cosmocloud_assignment/models/employee_model.dart';
import 'package:http/http.dart' as http;

class EmployeeService {
  static const String baseUrl =
      'https://free-ap-south-1.cosmocloud.io/development/api';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'projectId': '66aa81898f90e5d0511a0364',
    'environmentId': '66aa81898f90e5d0511a0365',
  };

  static Future<List<Employee>> getEmployees(
      {int limit = 10, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/employee?limit=$limit&offset=$offset'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((employee) => Employee.fromJson(employee)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  static Future<Employee> getEmployee(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/employee/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load employee');
    }
  }

  static Future<void> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employee'),
      headers: headers,
      body: json.encode(employee.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create employee');
    }
  }

  static Future<void> deleteEmployee(String id) async {
    final response = await http
        .delete(Uri.parse('$baseUrl/employee/$id'), headers: headers, body: {});

    if (response.statusCode != 200) {
      throw Exception('Failed to delete employee');
    }
  }
}
