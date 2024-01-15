import 'package:flutter/material.dart';
import 'package:demande_app/Demande.dart'; // Import your Demande class
import 'package:http/http.dart' as http;

class DemandDetailsScreen extends StatelessWidget {
  final Demande demand;
  final Function() onActionComplete;

  DemandDetailsScreen({required this.demand, required this.onActionComplete});

  Future<void> _showConfirmationDialog(BuildContext context, String action) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action this demand?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Perform the action (approve or reject) based on user confirmation
                if (action == 'Approve') {
                  await acceptDemand(context, demand.id.toString());
                } else if (action == 'Reject') {
                  await rejectDemand(context, demand.id.toString());
                }
              },
              child: Text(action),
              style: ElevatedButton.styleFrom(
                primary: action == 'Approve' ? Colors.green : Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> acceptDemand(BuildContext context, String id) async {
    final Uri uri = Uri.parse("http://localhost:8080/api/demandes/accept/$id");
    await http.put(uri);
    onActionComplete(); // Call the callback function
    Navigator.pop(context); // Navigate back to the demand list page
  }

  Future<void> rejectDemand(BuildContext context, String id) async {
    final Uri uri = Uri.parse("http://localhost:8080/api/demandes/refus/$id");
    await http.put(uri);
    onActionComplete(); // Call the callback function
    Navigator.pop(context); // Navigate back to the demand list page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demand Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${demand.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Description: ${demand.des}'),
            Text('Type: ${demand.type}'),
            Text('Date: ${demand.date}'),
            Text('Etat: ${demand.etat}'),
            Text('User: ${demand.user.username}'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Show confirmation dialog before approving the demand
                    await _showConfirmationDialog(context, 'Approve');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text('Approve'),
                ),
                SizedBox(width: 8.0), // Add some space between buttons
                ElevatedButton(
                  onPressed: () async {
                    // Show confirmation dialog before rejecting the demand
                    await _showConfirmationDialog(context, 'Reject');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
