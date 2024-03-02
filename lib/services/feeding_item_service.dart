import 'package:DigitalDairy/models/feeding_item.dart';
import "db_service.dart";

/// A service that gets, updates and deletes client information.
///
class FeedingItemService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _clientReference = DbService.currentUserDbReference
      .collection('feeding_items')
      .withConverter<FeedingItem>(
        fromFirestore: FeedingItem.fromFirestore,
        toFirestore: (FeedingItem client, _) => client.toFirestore(),
      );

  /// Loads the clients list from firebase firestore.
  Future<List<FeedingItem>> getFeedingItemsList() async {
    return await _clientReference.get().then((querySnapshot) => querySnapshot
        .docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

//add a client
  Future<FeedingItem?> addFeedingItem(FeedingItem client) async {
    return await _clientReference
        .add(client)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a client
  Future<void> deleteFeedingItem(FeedingItem client) async {
    return await _clientReference.doc(client.getId).delete();
  }

//update a client
  Future<FeedingItem> editFeedingItem(FeedingItem client) async {
    await _clientReference.doc(client.getId).update(client.toFirestore());
    return client;
  }
}
