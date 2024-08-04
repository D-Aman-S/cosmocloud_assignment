import 'package:cosmocloud_assignment/models/employee_model.dart';
import 'package:cosmocloud_assignment/services/api_services.dart';
import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _line1Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final List<Map<String, String>> _contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _line1Controller,
                decoration: const InputDecoration(labelText: 'Address Line 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address line 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a country';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'ZIP Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a ZIP code';
                  }
                  return null;
                },
              ),
              ..._contacts.map((contact) => ListTile(
                    title: Text('${contact['contact_method']}'),
                    subtitle: Text('${contact['value']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _contacts.remove(contact);
                        });
                      },
                    ),
                  )),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddContactDialog(
                      onAdd: (contactMethod, value) {
                        setState(() {
                          _contacts.add({
                            'contact_method': contactMethod,
                            'value': value
                          });
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                child: const Text('Add Contact'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _contacts.isEmpty
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final newEmployee = Employee(
                            name: _nameController.text,
                            address: Address(
                              line1: _line1Controller.text,
                              city: _cityController.text,
                              country: _countryController.text,
                              zipCode: _zipCodeController.text,
                            ),
                            contacts: _contacts
                                .map((contact) => Contact(
                                      contactMethod: contact['contact_method']!,
                                      value: contact['value']!,
                                    ))
                                .toList(),
                            id: '',
                          );
                          await EmployeeService.createEmployee(newEmployee);
                          Navigator.pop(context);
                        }
                      },
                child: const SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: Center(child: Text('Add Employee'))),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddContactDialog extends StatefulWidget {
  final Function(String, String) onAdd;

  AddContactDialog({super.key, required this.onAdd});

  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  String _selectedContactMethod = 'EMAIL';
  final _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Contact'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _selectedContactMethod,
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                _selectedContactMethod = value!;
              });
            },
            items: ['EMAIL', 'PHONE']
                .map((method) => DropdownMenuItem(
                      child: Text(method),
                      value: method,
                    ))
                .toList(),
          ),
          TextField(
            controller: _valueController,
            decoration: const InputDecoration(labelText: 'Value'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_valueController.text.isNotEmpty) {
              widget.onAdd(_selectedContactMethod, _valueController.text);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
