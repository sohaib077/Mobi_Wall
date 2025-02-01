import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
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
    if (ParentCubit.get(context).children.isEmpty) {
      ParentCubit.get(context).getChildren(context).then((value) {
        FirebaseService().updateUserToken().then((value) {
          log("parent token is updated successfully and token = \n$value");
        }).catchError((error) {
          log("Error while updating parent token : $error");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AddChildFloatingActionButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocBuilder<ParentCubit, ParentState>(
            builder: (context, state) {
              List<ChildDataModel> children = ParentCubit.get(context).children;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTitleAppBar(
                    title: "Children",
                    onBack: () {
                      CacheHelper.removeData( Constants.cachedIsParent);
                      navigateAndFinish(context, const HomeView(), x: -1, y: 0);
                    },
                    onRefresh: () {
                      if (ParentCubit.get(context).getChildrenState !=
                          MethodState.loading) {
                        ParentCubit.get(context).getChildren(context);
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomStateWidget(
                    state: ParentCubit.get(context).getChildrenState,
                    widget: ParentChildrenList(children: children),
                    onError: () =>
                        ParentCubit.get(context).getChildren(context),
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
}
