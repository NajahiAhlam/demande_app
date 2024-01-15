import 'package:demande_app/User.dart';

class Demande {
  final int id;
  final String des;
  final String type;
  final String date;
  final String etat;
  final User user;

  Demande({
    required this.id,
    required this.des,
    required this.type,
    required this.date,
    required this.etat,
    required this.user,
  });

  factory Demande.fromJson(Map<String, dynamic> json) {
    return Demande(
      id: json['id'],
      des: json['des'],
      type: json['type'],
      date: json['date'],
      etat: json['etat'],
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}