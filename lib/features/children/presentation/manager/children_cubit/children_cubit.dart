import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/helpers/cache_helper.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/children/presentation/views/children_view.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';
part 'children_state.dart';

class ChildrenCubit extends Cubit<ChildrenState> {
  ChildrenCubit() : super(ChildrenInitial());

  static ChildrenCubit get(context) => BlocProvider.of(context);

  late ChildDataModel childData;
  MethodState loginChildState = MethodState.init;

  void loginChild(context,
      {required String username, required String password}) {
    loginChildState = MethodState.loading;
    emit(LoginChildLoadingState());

    FirebaseService().loginChild(username: username).then((value) {
      childData = ChildDataModel.fromJson(value.data()!);
      if (childData.password == password) {
        loginChildState = MethodState.success;
        emit(LoginChildSuccessState());
        Future.delayed(const Duration(milliseconds: 500), () {
          loginChildState = MethodState.init;
          emit(LoginChildSuccessState());
          // Caching child data
          final jsonData = childData.toMap();
          CacheHelper.saveData(
              key: Constants.cachedChild, value: jsonEncode(jsonData));
          Constants.childData = childData;
          navigateAndFinish(context, const ChildrenView());
        });
      } else {
        throw ("\nWrong password\n");
      }
    }).catchError((error) {
      loginChildState = MethodState.init;
      emit(LoginChildFailureState());
      showAlertDialog(context,
          state: AlertState.failed, description: error.toString());
    });
  }

}
