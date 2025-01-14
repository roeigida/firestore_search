library firestore_search;

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService<T> {
  final String? collectionName;
  final String? searchBy;
  final List Function(QuerySnapshot)? dataListFromSnapshot;
  final int? limitOfRetrievedData;

  FirestoreService(
      {this.collectionName,
      this.searchBy,
      this.dataListFromSnapshot,
      this.limitOfRetrievedData});

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<List> searchDataAlgorithm(String query) {
    ///check if hebrew
    RegExp regExp = RegExp("[ -&(-+\-/-9=?-@^{}\u0590-\u05fe]", unicode: true);
    var isHebrew = regExp.hasMatch(query);
    final collectionReference = firebaseFirestore.collection(collectionName!);
    //For teacher search (userType = 0)
    if (collectionName == "users") {
      if (query.isEmpty) {
        return collectionReference
            .where('type', isEqualTo: 0)
            .limit(limitOfRetrievedData!)
            .snapshots()
            .map(dataListFromSnapshot!);
      } else if (isHebrew) {
        return collectionReference
            .orderBy('$searchBy', descending: false)
            .where('$searchBy', isGreaterThanOrEqualTo: query)
            .where('$searchBy', isLessThan: query + '\u05eb')
            .where('type', isEqualTo: 0)
            .limit(limitOfRetrievedData!)
            .snapshots()
            .map(dataListFromSnapshot!);
      } else {
        return collectionReference
            .orderBy('$searchBy', descending: false)
            .where('$searchBy', isGreaterThanOrEqualTo: query)
            .where('$searchBy', isLessThan: query + 'z')
            .where('type', isEqualTo: 0)
            .limit(limitOfRetrievedData!)
            .snapshots()
            .map(dataListFromSnapshot!);
      }
    }
    if (query.isEmpty) {
      return collectionReference
          .limit(limitOfRetrievedData!)
          .snapshots()
          .map(dataListFromSnapshot!);
    } else if (isHebrew) {
      return collectionReference
          .orderBy('$searchBy', descending: false)
          .where('$searchBy', isGreaterThanOrEqualTo: query)
          .where('$searchBy', isLessThan: query + '\u05eb')
          .limit(limitOfRetrievedData!)
          .snapshots()
          .map(dataListFromSnapshot!);
    } else {
      return collectionReference
          .orderBy('$searchBy', descending: false)
          .where('$searchBy', isGreaterThanOrEqualTo: query)
          .where('$searchBy', isLessThan: query + 'z')
          .limit(limitOfRetrievedData!)
          .snapshots()
          .map(dataListFromSnapshot!);
    }
  }
}
