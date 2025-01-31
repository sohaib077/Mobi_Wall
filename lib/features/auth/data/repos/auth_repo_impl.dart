import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobi_wall/core/errors/error_handler.dart';
import 'package:mobi_wall/core/errors/error_model.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';
import 'package:mobi_wall/features/auth/data/models/user_data_model.dart';

import 'auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseService _fb;

  AuthRepoImpl(this._fb);

  @override
  Future<Either<ErrorModel, UserDataModel>> login(
      {required String email, required String password}) async {
    try {
      /// Login
      final UserCredential userCredential =
          await _fb.loginUser(email: email, password: password);

      /// Get user data using login credential
      final userData = await _fb.getUserData(id: userCredential.user!.uid);
      return Right(UserDataModel.fromJson(userData.data()));
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ErrorModel, UserDataModel>> register(
      {required UserDataModel userData}) async {
    try {
      /// Just authenticating the user
      final UserCredential userCredential = await _fb.registerUser(
          email: userData.email, password: userData.password);
      User firebaseUser = userCredential.user!;
      userData.id = firebaseUser.uid;
      try {
        /// Adding all user's data
        await _fb.setUserData(userData: userData);
        return Right(userData);
      } catch (e) {
        /// Deleting user if its data not added
        // await _fb.deleteUser();
        rethrow;
      }
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
