import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const EmployeeCrudApp());
}

class EmployeeCrudApp extends StatelessWidget {
  const EmployeeCrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee CRUD App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
