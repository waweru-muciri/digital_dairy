import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  static final clientReference = FirebaseFirestore.instance
      .collection("farmers")
      .doc("UYeFZgo47bsbaLDsRGnA");
}
