// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/functions/setup_service_locator.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/core/widgets/unfocus.dart';
import 'package:mobi_wall/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobi_wall/features/auth/presentation/views/widgets/login_view.dart';
import 'package:mobi_wall/features/auth/presentation/views/widgets/signup_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: Unfocus(
        child: Scaffold(
          body: SafeArea(
              child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) => _listener(context, state),
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AuthCubit.get(context).signInView
                    ? LoginView()
                    : SignupView(),
              );
            },
          )),
        ),
      ),
    );
  }

  _listener(BuildContext context, AuthState state) {
    if (state is LoginFailureState)
      showAlertDialog(context,
          title: 'Login Failed', description: state.message);
    else if (state is RegisterFailureState)
      showAlertDialog(context,
          title: 'Register Failed', description: state.message);
    // else if (state is LoginSuccessState || state is RegisterSuccessState)
      // navigateAndFinish(context, const HomeView(), fade: true);
  }
}
