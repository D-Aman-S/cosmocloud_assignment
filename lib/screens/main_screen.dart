import 'package:cosmocloud_assignment/services/api_services.dart';
import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../screens/add_employee.dart';
import '../screens/employee_details.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Employee> _employees = [];
  int _limit = 10;
  int _offset = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Employee> employees =
          await EmployeeService.getEmployees(limit: _limit, offset: _offset);
      setState(() {
        _employees.addAll(employees);
        _hasMore = employees.length == _limit;
        _offset += _limit;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshEmployees() async {
    setState(() {
      _employees.clear();
      _offset = 0;
      _hasMore = true;
    });
    await _loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshEmployees,
        child: _employees.isEmpty
            ? Center(child: Text('No Employees in the system'))
            : ListView.builder(
                itemCount: _employees.length + 1,
                itemBuilder: (context, index) {
                  if (index == _employees.length) {
                    if (_hasMore) {
                      _loadEmployees();
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container();
                    }
                  }

                  Employee employee = _employees[index];
                  return ListTile(
                    title: Text(employee.name),
                    subtitle: Text(employee.id),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EmployeeDetailsScreen(employeeId: employee.id),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await EmployeeService.deleteEmployee(employee.id);
                        _refreshEmployees();
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
