import 'package:cosmocloud_assignment/models/employee_model.dart';
import 'package:cosmocloud_assignment/services/api_services.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final String employeeId;

  EmployeeDetailsScreen({required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
      ),
      body: FutureBuilder<Employee>(
        future: EmployeeService.getEmployee(employeeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No employee data'));
          } else {
            final employee = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${employee.name}',
                      style: const TextStyle(fontSize: 18)),
                  Text('ID: ${employee.id}',
                      style: const TextStyle(fontSize: 18)),
                  const Text('Address:', style: TextStyle(fontSize: 18)),
                  Text('Line 1: ${employee.address.line1}',
                      style: const TextStyle(fontSize: 18)),
                  Text('City: ${employee.address.city}',
                      style: const TextStyle(fontSize: 18)),
                  Text('Country: ${employee.address.country}',
                      style: const TextStyle(fontSize: 18)),
                  Text('ZIP Code: ${employee.address.zipCode}',
                      style: const TextStyle(fontSize: 18)),
                  const Text('Contacts:', style: TextStyle(fontSize: 18)),
                  ...employee.contacts.map((contact) => Text(
                      '${contact.contactMethod}: ${contact.value}',
                      style: const TextStyle(fontSize: 18))),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
