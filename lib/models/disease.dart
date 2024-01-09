import "package:cloud_firestore/cloud_firestore.dart";

class Disease {
  String? _id;
  late String _name;
  late String _details;
  late String _dateDiscovered;

  String? get getId => _id;

  set setId(String? value) => _id = value;

  get getName => _name;

  set setName(value) => _name = value;

  get getDetails => _details;

  set setDetails(value) => _details = value;

  get getDateDiscovered => _dateDiscovered;

  set setDateDiscovered(value) => _dateDiscovered = value;

  Disease();

  factory Disease.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;
    final newDisease = Disease();
    newDisease.setDateDiscovered = data?["dateDiscovered"];
    newDisease.setName = data?["name"];
    newDisease.setId = id;
    newDisease.setDetails = data?["details"];
    return newDisease;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'details': _details,
      'name': _name,
      "dateDiscovered": _dateDiscovered,
      'id': _id
    };
  }
}
