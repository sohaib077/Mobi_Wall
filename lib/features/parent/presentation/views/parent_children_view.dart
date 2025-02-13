import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/functions/setup_service_locator.dart';
import 'package:mobi_wall/core/helpers/cache_helper.dart';
import 'package:mobi_wall/core/services/firebase_services.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/widgets/customStateWidget.dart';
import 'package:mobi_wall/core/widgets/custom_empty_state_widget.dart';
import 'package:mobi_wall/core/widgets/custom_title_app_bar.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/home/presentation/views/home_view.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/parent_children_list.dart';

import 'widgets/add_child_floating_action_button.dart';

class ParentChildrenView extends StatefulWidget {
  const ParentChildrenView({super.key});

  @override
  State<ParentChildrenView> createState() => _ParentChildrenViewState();
}

class _ParentChildrenViewState extends State<ParentChildrenView> {
  @override
  void initState() {
    super.initState();
    FirebaseService().updateUserToken().then((value) {
      log("parent token is updated successfully and token = \n$value");
    }).catchError((error) {
      log("Error while updating parent token : $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: const AddChildFloatingActionButton(),
      body: BlocProvider.value(
        value: sl<ParentCubit>()..getChildren(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocConsumer<ParentCubit, ParentState>(
            listener: (context, state) => _listener(context, state),
            builder: (context, state) {
              List<ChildDataModel> children = ParentCubit.get(context).children;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTitleAppBar(
                    title: "Children",
                    onBack: () {
                      CacheHelper.removeData(Constants.cachedIsParent);
                      navigateAndFinish(context, const HomeView(), x: -1, y: 0);
                    },
                    onRefresh: () {
                      ParentCubit.get(context).getChildren();
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomStateWidget(
                    state: ParentCubit.get(context).getChildrenState,
                    widget: ParentChildrenList(children: children),
                    onError: () => ParentCubit.get(context).getChildren(),
                    emptyWidget: const CustomEmptyStateWidget(),
                  ),
                  SizedBox(height: 50.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _listener(BuildContext context, ParentState state) {
    if (state is GetChildrenFailureState || state is AddChildFailureState) {
      showAlertDialog(context, description: (state as dynamic).message);
    }
  }
}
