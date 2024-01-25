import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/services/db_service.dart';

/// A service that gets, updates and deletes milk production information.
///
class DailyMilkProductionService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _milkProductionReference = DbService.currentUserDbReference
      .collection('daily_milk_production')
      .withConverter<DailyMilkProduction>(
        fromFirestore: DailyMilkProduction.fromFirestore,
        toFirestore: (DailyMilkProduction dailyMilkProduction, _) =>
            dailyMilkProduction.toFirestore(),
      );
  Future<List<DailyMilkProduction>> getDailyMilkProductionsListBetweenDates(
      String startDate,
      {String? endDate}) async {
    if (startDate.isNotEmpty && endDate != null) {
      return await _milkProductionReference
          .orderBy("milk_production_date")
          .where("milk_production_date", isGreaterThanOrEqualTo: startDate)
          .where("milk_production_date", isLessThanOrEqualTo: endDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    } else {
      return await _milkProductionReference
          .orderBy("milk_production_date")
          .where("milk_production_date", isEqualTo: startDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    }
  }

//add a milk production
  Future<DailyMilkProduction?> addMilkProduction(
      DailyMilkProduction milkProduction) async {
    return await _milkProductionReference
        .add(milkProduction)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a milk production
  Future<void> deleteMilkProduction(DailyMilkProduction milkProduction) async {
    return await _milkProductionReference.doc(milkProduction.getId).delete();
  }

//update a milk production
  Future<DailyMilkProduction> editMilkProduction(
      DailyMilkProduction milkProduction) async {
    await _milkProductionReference
        .doc(milkProduction.getId)
        .update(milkProduction.toFirestore());
    return milkProduction;
  }
}
