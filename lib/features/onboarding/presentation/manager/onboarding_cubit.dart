import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  static OnboardingCubit get(context) => BlocProvider.of(context);

  double currentIndex = 0;

  void changeIndex(double index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }

  bool letsGo = false;

  void changeLetsGo({required bool value}) {
    if (letsGo != value) {
      letsGo = value;
      emit(ChangeLetsGoState());
    }
  }
}
