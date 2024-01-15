import 'package:flutter/material.dart';
import 'package:demande_app/Demande.dart'; // Import your Demande class
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateDemandScreen extends StatefulWidget {
  final int demandId;

  UpdateDemandScreen({required this.demandId});

  @override
  _UpdateDemandScreenState createState() => _UpdateDemandScreenState();
}

class _UpdateDemandScreenState extends State<UpdateDemandScreen> {
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
    
   
    // Fetch existing demand details and populate the text controllers
    fetchDemandDetails();
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
        dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
  }

  Future<void> fetchDemandDetails() async {
    final Uri uri = Uri.parse("http://localhost:8080/api/demandes/id/${widget.demandId}");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        setState(() {
          descriptionController.text = decodedData['des'];
          typeController.text = decodedData['type'];
          dateController.text = decodedData['date'];
          etatController.text = decodedData['etat'];
          // Add more lines for other fields
        });
      } else {
        throw Exception('Failed to load demand details');
      }
    } catch (error) {
      print('Error fetching demand details: $error');
    }
  }

  Future<void> updateDemand() async {
    final Uri uri = Uri.parse("http://localhost:8080/api/demandes/update/${widget.demandId}");

    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'des': descriptionController.text,
          'type': typeController.text,
          'date': dateController.text,
          'etat': etatController.text,
          // Add more fields as needed
        }),
      );

     if (response.statusCode == 200) {
  // Successfully updated, you might want to navigate back to the list screen
  Navigator.pop(context, true); // Pass true as a result indicating a successful update
} else {
  throw Exception('Failed to update demand');
}
    } catch (error) {
      print('Error updating demand: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Demand'),
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
            ), TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            TextField(
              controller: etatController,
               enabled: false,
              decoration: InputDecoration(labelText: 'Etat'),
            ),
            // Add more TextField widgets for other fields
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Call the update function when the button is pressed
                updateDemand();
              },
              child: Text('Update Demand'),
            ),
          ],
        ),
      ),
    );
  }
}
