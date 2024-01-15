import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CreateDemandScreen extends StatefulWidget {
  final VoidCallback onDemandCreated;

  CreateDemandScreen({required this.onDemandCreated});

  @override
  _CreateDemandScreenState createState() => _CreateDemandScreenState();
}

class _CreateDemandScreenState extends State<CreateDemandScreen> {
  late TextEditingController descriptionController;
  late TextEditingController typeController;
  late TextEditingController dateController;
  late TextEditingController etatController;
  late DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    typeController = TextEditingController();
    dateController = TextEditingController();
    etatController = TextEditingController();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
      });
  }

  void createDemand() async {
    // Retrieve the username from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    // Retrieve the current user from the backend
    String apiUrl = "http://localhost:8080/api/auth/users/username/$username";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        dynamic userData = json.decode(response.body);

        // Save the demand including the user
        String apiUrlCreateDemand = "http://localhost:8080/api/demandes";
        final responseCreateDemand = await http.post(
          Uri.parse(apiUrlCreateDemand),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'des': descriptionController.text,
            'type': typeController.text,
            'date': dateController.text,
            'etat': 'Inprogress',
            'user': {"id": userData["id"]},
          }),
        );

        if (responseCreateDemand.statusCode == 200) {
          widget.onDemandCreated();
          Navigator.pop(context, true);
        } else {
          print("Error creating demand: ${responseCreateDemand.body}");
        }
      } else {
        print("Error retrieving user: ${response.body}");
      }
    } catch (error) {
      print("Error creating demand: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Demand'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 1.0,
              color: Colors.grey[300],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    createDemand();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Create Demand',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
