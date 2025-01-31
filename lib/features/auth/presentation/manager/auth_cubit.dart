import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/helpers/user_data_helper.dart';
import 'package:mobi_wall/features/auth/data/models/user_data_model.dart';

import '../../data/repos/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepo) : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  final AuthRepo _authRepo;

  bool signInView = true;

  void changeSignInView({required bool value}) {
    signInView = value;
    emit(ChangeSignInViewState());
  }

  /// ////////////////////////// LOGIN /////////////////////////////////

  MethodState loginState = MethodState.init;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (loginState.isLoading()) return;
    loginState = MethodState.loading;
    emit(LoginLoadingState());
    final result = await _authRepo.login(email: email, password: password);

    result.fold(
      (error) {
        loginState = MethodState.failed;
        emit(LoginFailureState(error.getErrorsMessage()));
      },
      (userData) async {
        // caching the id to avoid login every time
        await UserDataHelper.cacheUserData(userData);

        loginState = MethodState.success;
        emit(LoginSuccessState());
      },
    );
  }

  /// ////////////////////////// REGISTER /////////////////////////////////

  MethodState registerState = MethodState.init;

  Future<void> register(
    context, {
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (registerState.isLoading()) return;
    registerState = MethodState.loading;
    emit(RegisterLoadingState());

    final result = await _authRepo.register(
      userData: UserDataModel(
        name: name,
        email: email,
        password: password,
        phone: phone,
      ),
    );

    result.fold(
      (error) {
        registerState = MethodState.failed;
        emit(RegisterFailureState(error.getErrorsMessage()));
      },
      (userData) async {
        // caching the id to avoid login every time
        await UserDataHelper.cacheUserData(userData);
        registerState = MethodState.success;
        emit(RegisterSuccessState());
      },
    );
  }
}
