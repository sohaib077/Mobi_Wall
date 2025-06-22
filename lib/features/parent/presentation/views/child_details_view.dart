import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/functions/setup_service_locator.dart';
import 'package:mobi_wall/core/widgets/custom_nav_bar/custom_bottom_navigation_bar.dart';
import 'package:mobi_wall/core/widgets/custom_title_app_bar.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/block_url_floating_action_button.dart';

class ChildDetailsView extends StatelessWidget {
  const ChildDetailsView({super.key, required this.child});

  final ChildDataModel child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ParentCubit>(),
      child: BlocBuilder<ParentCubit, ParentState>(
        builder: (context, state) {
          final currentPage = ParentCubit.get(context).currentTab;
          return Scaffold(
            appBar: AppBar(),
            floatingActionButton:
                currentPage == 4 ? const BlockUrlFloatingActionButton() : null,
            bottomNavigationBar: const CustomBottomNavigationBar(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  CustomTitleAppBar(title: child.username),
                  ParentCubit.get(context).getCurrentBody(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
