import 'package:DigitalDairy/models/feeding_item.dart';
import "db_service.dart";

/// A service that gets, updates and deletes feedingItem information.
///
class FeedingItemService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _feedingItemReference = DbService.currentUserDbReference
      .collection('feeding_items')
      .withConverter<FeedingItem>(
        fromFirestore: FeedingItem.fromFirestore,
        toFirestore: (FeedingItem feedingItem, _) => feedingItem.toFirestore(),
      );

  /// Loads the feedingItems list from firebase firestore.
  Future<List<FeedingItem>> getFeedingItemsList() async {
    return await _feedingItemReference.get().then((querySnapshot) =>
        querySnapshot.docs
            .map((documentSnapshot) => documentSnapshot.data())
            .toList());
  }

//add a feedingItem
  Future<FeedingItem?> addFeedingItem(FeedingItem feedingItem) async {
    return await _feedingItemReference
        .add(feedingItem)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a feedingItem
  Future<void> deleteFeedingItem(FeedingItem feedingItem) async {
    return await _feedingItemReference.doc(feedingItem.getId).delete();
  }

//update a feedingItem
  Future<FeedingItem> editFeedingItem(FeedingItem feedingItem) async {
    await _feedingItemReference
        .doc(feedingItem.getId)
        .update(feedingItem.toFirestore());
    return feedingItem;
  }
}
