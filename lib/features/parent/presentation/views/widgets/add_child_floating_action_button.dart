import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/add_child_bottom_sheet.dart';

class AddChildFloatingActionButton extends StatelessWidget {
  const AddChildFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      backgroundColor: AppColors.primaryColor,
      onPressed: () {
        showModalBottomSheet(
          shape: Constants.modalSheetDecoration(),
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return const AddChildBottomSheet();
          },
        );
      },
      label: Text(
        'Add child',
        style: Styles.medium25Style(context, size: 14).copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
