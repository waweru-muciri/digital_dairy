import "package:cloud_firestore/cloud_firestore.dart";

class Cow {
  String? _id;
  late String _name;
  late String _cowId;

  Cow();

  get getId => _id;

  set setId(id) => _id = id;

  get getName => _name;

  set setName(firstName) => _name = firstName;

  get getCowId => _cowId;

  set setCowId(String cowId) => _cowId = cowId;

  factory Cow.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    Cow newCow = Cow();
    newCow.setName = data?["name"];
    newCow.setCowId = data?["cow_id"];
    newCow.setId = id;

    return newCow;
  }

  factory Cow.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["cow"];
    final String id = snapshot.id;

    Cow newCow = Cow();
    newCow.setName = data?["name"];
    newCow.setCowId = data?["cow_id"];
    newCow.setId = id;

    return newCow;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow_id': _cowId,
      'name': _name,
      'id': _id,
    };
  }

  String get cowName => '$_name $_cowId';
}
