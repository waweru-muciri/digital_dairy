import 'package:DigitalDairy/models/cow_death.dart';
import "db_service.dart";

/// A service that gets, updates and deletes cowdeath information.
///
class CowDeathService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _cowdeathReference = DbService.currentUserDbReference
      .collection('cow_deaths')
      .withConverter<CowDeath>(
        fromFirestore: CowDeath.fromFirestore,
        toFirestore: (CowDeath cowdeath, _) => cowdeath.toFirestore(),
      );

  Future<List<CowDeath>> getCowDeathsListBetweenDates(String startDate,
      {String? endDate}) async {
    if (startDate.isNotEmpty && endDate != null) {
      return await _cowdeathReference
          .where("date_of_death", isGreaterThanOrEqualTo: startDate)
          .where("date_of_death", isLessThanOrEqualTo: endDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    } else {
      return await _cowdeathReference
          .where("date_of_death", isEqualTo: startDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    }
  }

//add a cowdeath
  Future<CowDeath?> addCowDeath(CowDeath cowdeath) async {
    return await _cowdeathReference
        .add(cowdeath)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a cowdeath
  Future<void> deleteCowDeath(CowDeath cowdeath) async {
    return await _cowdeathReference.doc(cowdeath.getId).delete();
  }

//update a cowdeath
  Future<CowDeath> editCowDeath(CowDeath cowdeath) async {
    await _cowdeathReference.doc(cowdeath.getId).update(cowdeath.toFirestore());
    return cowdeath;
  }
}
