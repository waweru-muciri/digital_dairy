import "package:cloud_firestore/cloud_firestore.dart";

class Disease {
  final String id;
  final String name;
  final String details;
  final DateTime dateDiscovered;

  Disease({
    this.id = "",
    this.details = "",
    required this.dateDiscovered,
    required this.name,
  });

  factory Disease.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    return Disease(
        name: data?["name"],
        dateDiscovered: data?["dateDiscovered"],
        details: data?["details"],
        id: id);
  }

  Map<String, dynamic> toFirestore() {
    return {'details': details, 'name': name, "dateDiscovered": dateDiscovered};
  }
}
