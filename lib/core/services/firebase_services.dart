import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobi_wall/features/auth/data/models/user_data_model.dart';
import 'package:mobi_wall/features/children/data/models/location_data_model.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';

import '../utils/constants.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() => _auth.signOut();

  /// ///////////////////////     COLLECTION NAMES      ///////////////////////////////

  static const String _usersCollection = "users";
  static const String _childrenCollection = "children";
  static const String _appsCollection = "apps";

  /// ///////////////////////     AUTH      ///////////////////////////////
  Future<UserCredential> registerUser({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// ///////////////////////     USER DATA      ///////////////////////////////

  Future<void> setUserData({required UserDataModel userData}) async {
    return await _db
        .collection(_usersCollection)
        .doc(userData.id)
        .set(userData.toMap());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(
      {required String id}) async {
    return await _db.collection(_usersCollection).doc(id).get();
  }

  Future<String?> updateUserToken() async {
    String? token = await Constants.getToken();

    if (token != null) {
      await _db
          .collection(_usersCollection)
          .doc(Constants.id!)
          .update({"token": token});
    }
    return token;
  }

  /// ///////////////////////     CHILD DATA      ///////////////////////////////

  static final CollectionReference<Map<String, dynamic>> _childRF = _db
      .collection(_usersCollection)
      .doc(Constants.userData.id)
      .collection(_childrenCollection);

  Future<bool> checkIfChildExists({
    required ChildDataModel childData,
  }) async {
    return await _db
        .collection(_usersCollection)
        .doc(Constants.userData.id)
        .collection(_childrenCollection)
        .doc(childData.username)
        .get()
        .then((value) {
      if (value.exists) return true;
      return false;
    });
  }

  Future<void> setChildData({
    required ChildDataModel childData,
  }) async {
    return await _db
        .collection(_usersCollection)
        .doc(Constants.userData.id)
        .collection(_childrenCollection)
        .doc(childData.username)
        .set(childData.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getChildren() async {
    return await _childRF.get();
  }

  Future<void> deleteChild({required String username}) async {
    return await _childRF.doc(username).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> loginChild(
      {required String username}) async {
    await _childRF.doc(username).get().then((value) {
      if (!value.exists) throw ("\nWrong username\n");
    });

    return await _db
        .collection(_usersCollection)
        .doc(Constants.userData.id)
        .collection(_childrenCollection)
        .doc(username)
        .get();
  }

  Future<String?> updateChildToken() async {
    String? token = await Constants.getToken();

    if (token != null) {
      await _db
          .collection(_usersCollection)
          .doc(Constants.userData.id)
          .collection(_childrenCollection)
          .doc(Constants.childData!.username)
          .update({"token": token});
    }
    return token;
  }

  /// ///////////////////////     APPS & LOCATION DATA      ///////////////////////////////

  static final DocumentReference<Map<String, dynamic>> _appsDocRef = _db
      .collection(_usersCollection)
      .doc(Constants.id)
      .collection(_childrenCollection)
      .doc(Constants.childData!.username);

  Future<void> refreshAppsData({
    required List<Map<String, dynamic>> apps,
  }) async {
    await _appsDocRef.update({'apps': apps, 'updatedDate': DateTime.now()});
  }

  Future<void> refreshLocationData({
    required LocationDataModel location,
  }) async {
    await _appsDocRef.update({'location': location.toMap()});
  }

  Future<void> updateBlockedApps({
    required List<String> blockedApps,
    required String childUsername,
  }) async {
    await _db
        .collection(_usersCollection)
        .doc(Constants.id)
        .collection(_childrenCollection)
        .doc(childUsername)
        .update({'blockedApps': blockedApps});
  }

  Future<void> updateBlockedUrls({
    required List<String> blockedUrls,
    required String childUsername,
  }) async {
    await _db
        .collection(_usersCollection)
        .doc(Constants.id)
        .collection(_childrenCollection)
        .doc(childUsername)
        .update({'blockedUrls': blockedUrls});
  }
}
