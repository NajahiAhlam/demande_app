import 'package:demande_app/DemandeDetailsScreen.dart';
import 'package:demande_app/update_demand.dart';
import 'package:flutter/material.dart';
import 'package:demande_app/Demande.dart'; // Import your Demande class
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DemandList extends StatefulWidget {
  @override
  _DemandListState createState() => _DemandListState();
}

class _DemandListState extends State<DemandList> {
  List<Demande> demands = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  
   void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void navigateToDemandDetailsScreen(BuildContext context, Demande demand) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DemandDetailsScreen(
          demand: demand,
          onActionComplete: () {
            fetchData(); 
          },
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    final Uri uri = Uri.parse("http://localhost:8080/api/demandes");

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

  Color getStatusColor(String etat) {
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
  }

  Future<void> deleteDemand(int id) async {
    final Uri uri = Uri.parse("http://localhost:8080/api/demandes/delete/id/$id");

    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
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
          Container(
            margin: EdgeInsets.only(right: 30.0),
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
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
                    DataCell(
                      Container(
                        color: getStatusColor(demand.etat),
                        child: Center(child: Text(demand.etat)),
                      ),
                    ),
                    DataCell(Text(demand.user.username)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_red_eye,
                            color: Colors.green,),
                            onPressed: () {
                              navigateToDemandDetailsScreen(context, demand);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,color: Colors.red,),
                            onPressed: () {
                              deleteDemand(demand.id);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,color: Colors.blue,),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateDemandScreen(demandId: demand.id),
                                ),
                              );

                              if (result == true) {
                                fetchData();
                              }
                            },
                            color: Theme.of(context).primaryColor,
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
    );
  }
}
