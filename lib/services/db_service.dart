import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbService {
  static final clientReference = FirebaseFirestore.instance
      .collection("farmers")
      .doc("UYeFZgo47bsbaLDsRGnA");

  static final currentUser = FirebaseAuth.instance.currentUser;
}
