import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/otp/presentation/views/otp_view.dart';
import 'package:mobi_wall/features/parent/presentation/views/parent_view.dart';
import 'package:mobi_wall/features/children/presentation/views/children_login_view.dart';

class ParentOrChildButton extends StatelessWidget {
  const ParentOrChildButton({
    super.key,
    required this.isParent,
  });

  final bool isParent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isParent
            ? Constants.otp
                ? navigateTo(context, OtpView(phone: Constants.userData.phone))
                : navigateTo(context, const ParentView())
            : navigateTo(context, const ChildrenLoginView());
      },
      borderRadius: BorderRadius.circular(11.r),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xffC7C7C7), width: 1.w)),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(isParent ? AssetsData.parentIcon : AssetsData.childIcon,
                width: 35.w),
            SizedBox(width: 10.w),
            Text(
              isParent ? "Parents" : "Children",
              style: Styles.medium25Style(context, size: 14)
                  .copyWith(color: const Color(0xff191919)),
            ),
          ],
        ),
      ),
    );
  }
}
