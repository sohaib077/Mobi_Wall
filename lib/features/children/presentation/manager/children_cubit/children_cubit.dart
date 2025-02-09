import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/helpers/cache_helper.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/features/children/data/repos/child_repo.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';

part 'children_state.dart';

class ChildrenCubit extends Cubit<ChildrenState> {
  ChildrenCubit(this._childRepo) : super(ChildrenInitial());

  static ChildrenCubit get(context) => BlocProvider.of(context);

  final ChildRepo _childRepo;
  late ChildDataModel childData;
  MethodState loginChildState = MethodState.init;

  Future<void> loginChild(
      {required String username, required String password}) async {
    if (loginChildState.isLoading()) return;
    loginChildState = MethodState.loading;
    emit(LoginChildLoadingState());

    final result =
        await _childRepo.childLogin(username: username, password: password);
    result.fold(
      (error) {
        loginChildState = MethodState.failed;
        emit(LoginChildFailureState(error.getErrorsMessage()));
      },
      (data) async {
        childData = data;
        await CacheHelper.saveJsonData(
            key: Constants.cachedChild, jsonData: childData.toMap());
        Constants.childData = childData;
        loginChildState = MethodState.success;
        emit(LoginChildSuccessState());
      },
    );
  }
}
