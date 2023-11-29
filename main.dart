import 'package:flutter/material.dart';

void main() {
  runApp(PayrollApp());
}

class PayrollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payroll System',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set your desired primary color
      ),
      home: PayrollScreen(),
    );
  }
}

class PayrollScreen extends StatefulWidget {
  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  List<Employee> employees = [];
  String selectedJobRole = 'Software Developer'; // Default job role

  // Map of job roles to their respective hourly rates
  Map<String, double> JobRoleHourlyRates = {
    'Software Developer': 20.0,
    'Graphic Designer': 18.0,
    'Accountant': 22.0,
    'Project Manager': 25.0,
    'HR Specialist': 18.0,
  };

  // List of job roles for the dropdown
  List<String> jobRoles = [
    'Software Developer',
    'Graphic Designer',
    'Accountant',
    'Project Manager',
    'HR Specialist',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payroll System'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedJobRole,
              onChanged: (String? newValue) {
                setState(() {
                  selectedJobRole = newValue!;
                });
              },
              items: jobRoles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              padding: EdgeInsets.all(8.0),
              children: [
                _buildDashboardItem('Total Employees', employees.length.toString(), Colors.green),
                _buildDashboardItem('Total Salary', '\$${_calculateTotalSalary().toStringAsFixed(2)}', Colors.blue),
                // Add more dashboard items as needed
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    color: Colors.grey[200], // Set your desired card color
                    child: ListTile(
                      title: Text(
                        '${employees[index].name}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text('Job Role: ${employees[index].jobRole}'),
                          Text('Salary: \$${employees[index].calculateSalary().toStringAsFixed(2)}'),

                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEmployeeDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDashboardItem(String title, String value, Color color) {
    return Card(
      elevation: 3,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(value),
          ],
        ),
      ),
    );
  }

  double _calculateTotalSalary() {
    return employees.fold(0.0, (total, employee) => total + employee.calculateSalary());
  }

  void _showAddEmployeeDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController hoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Employee'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Employee Name'),
              ),
              TextField(
                controller: hoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Worked Hours'),
              ),
              DropdownButton<String>(
                value: selectedJobRole,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedJobRole = newValue!;
                  });
                },
                items: jobRoles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String name = nameController.text;
                double hours = double.tryParse(hoursController.text) ?? 0.0;

                if (name.isNotEmpty && hours >= 0) {
                  setState(() {
                    employees.add(Employee(name: name, hoursWorked: hours, jobRole: selectedJobRole));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Employee {
  final String name;
  final double hoursWorked;
  final String jobRole;
  static Map<String, double>? JobRoleHourlyRates; // Static property

  Employee({required this.name, required this.hoursWorked, required this.jobRole });

  double get hourlyRate => JobRoleHourlyRates?[jobRole] ?? 15.0;

  double calculateSalary() {
    return hoursWorked * hourlyRate;
  }
}

