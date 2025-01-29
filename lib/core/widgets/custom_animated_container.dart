import 'package:flutter/material.dart';
import 'package:mobi_wall/core/enums/method_state_enum.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import '../utils/app_colors.dart';

class CustomAnimatedContainer extends StatefulWidget {
  const CustomAnimatedContainer(
      {super.key, required this.child, required this.state});

  final Widget child;
  final MethodState state;

  @override
  State<CustomAnimatedContainer> createState() =>
      _CustomAnimatedContainerState();
}

class _CustomAnimatedContainerState extends State<CustomAnimatedContainer> {
  bool animating = true;

  @override
  Widget build(BuildContext context) {
    // MethodState state = AuthCubit.get(context).loginState;
    bool stretched = animating || widget.state.isInit();
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
        onEnd: () => setState(() => animating = !animating),
        width: widget.state == MethodState.init
            ? MediaQuery.of(context).size.width
            : 70.res(context),
        child: !stretched
            ? loadingButton(widget.state.isSuccess())
            : widget.child,
      ),
    );
  }

  Container loadingButton(bool done) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? Colors.green : AppColors.primaryColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.res(context),
        vertical: 8.res(context),
      ),
      child: done
          ? Icon(Icons.done_rounded, color: Colors.white, size: 40.res(context))
          : SizedBox(
              // height: 35.h,
              width: 35.res(context),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3.res(context),
                  // strokeAlign: 2,
                ),
              ),
            ),
    );
  }
}
