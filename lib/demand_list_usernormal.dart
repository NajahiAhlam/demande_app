import 'package:demande_app/CreateDemandScreen.dart';
import 'package:demande_app/update_demand.dart';
import 'package:flutter/material.dart';
import 'package:demande_app/Demande.dart'; // Import your Demande class
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DemandListu extends StatefulWidget {
  @override
  _DemandListuState createState() => _DemandListuState();
}

class _DemandListuState extends State<DemandListu> {
  List<Demande> demands = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  

  Future<String> getUsernameFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ?? ''; // Default value if username is not found
}

  Future<void> fetchData() async {
    String username = await getUsernameFromStorage();
    final Uri uri = Uri.parse("http://localhost:8080/api/demandes/user/username/$username");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        setState(() {
          demands =
              decodedData.map((data) => Demande.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to load demands');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  /*Color getStatusColor(String etat) {
    switch (etat) {
      case 'acceptee':
        return Colors.green;
      case 'refusee':
        return Colors.red;
      case 'Inprogress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }*/

void refreshList() {
    fetchData();
  }

  void logout() async {
    // Supprimer le username du local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');

    // Naviguer vers la page de connexion
    Navigator.pushReplacementNamed(context, '/login'); // Utilisez le nom de la route de la page de connexion
  }

  Future<void> deleteDemand(int id) async {
    final Uri uri = Uri.parse("http://localhost:8080/api/demandes/delete/id/$id");

    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        // Successfully deleted, you might want to refresh the list
        fetchData();
      } else {
        throw Exception('Failed to delete demand');
      }
    } catch (error) {
      print('Error deleting demand: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demande List'),
       actions: [
          // Ajouter un bouton de déconnexion à droite de la barre d'applications
          Container(
            margin: EdgeInsets.only(right: 30.0), // Ajuster la marge à gauche
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Appeler la fonction de déconnexion lorsque le bouton est pressé
                logout();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Etat')),
            DataColumn(label: Text('User')),
            DataColumn(label: Text('Actions')),
          ],
          rows: demands
              .map(
                (demand) => DataRow(
                  cells: [
                    DataCell(Text(demand.id.toString())),
                    DataCell(Text(demand.des)),
                    DataCell(Text(demand.type)),
                    DataCell(Text(demand.date)),
                    DataCell(Text(demand.etat)),
                   
                   
                     DataCell(Text(demand.user.username)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete,color: Colors.red,),
                            onPressed: () {
                              // Call the delete function when the button is pressed
                              deleteDemand(demand.id);
                            },
                          ),
                         IconButton(
  icon: Icon(Icons.edit,color: Colors.blue,),
  onPressed: () async {
    // Navigate to the update screen with the demand ID
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateDemandScreen(demandId: demand.id),
      ),
    );

    // Check if the result indicates a successful update, then refresh the list
    if (result == true) {
      fetchData();
    }
  },
),

                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
     floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Attendre que la page CreateDemandScreen soit fermée
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateDemandScreen(
                onDemandCreated: refreshList,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
