import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';

class BottomNavigationBarTabItem extends StatelessWidget {
  const BottomNavigationBarTabItem({
    super.key,
    this.tapIcon,
    required this.tapName,
    required this.index,
    this.iconData,
    this.selectedIconData,
  });

  final String? tapIcon;
  final String tapName;
  final int index;
  final IconData? iconData;
  final IconData? selectedIconData;

  @override
  Widget build(BuildContext context) {
    bool selected = ParentCubit.get(context).currentTab == index;
    const Color secondary = Colors.black;
    return Expanded(
      child: InkWell(
        onTap: () {
          ParentCubit.get(context).changeTab(index);
        },
        child: Column(
          children: [
            if (tapIcon != null)
              SvgPicture.asset(
                tapIcon!,
                width: 27.w,
                colorFilter: selected
                    ? const ColorFilter.mode(Colors.black, BlendMode.srcIn)
                    : null,
              ),
            if (iconData != null)
              Icon(
                selected && selectedIconData != null
                    ? selectedIconData!
                    : iconData!,
                size: 27.sp,
              ),
            // const SizedBox(height: 2),
            Text(
              tapName,
              style: selected
                  ? Styles.medium16Style(context, size: 14)
                      .copyWith(color: Colors.black)
                  : Styles.regular14Style(context).copyWith(color: secondary),
            )
                .animate(target: selected ? 1 : 0)
                .fade(duration: 500.ms)
                .slideY(begin: 2, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
