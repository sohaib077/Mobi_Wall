import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/widgets/custom_card.dart';
import 'package:mobi_wall/core/widgets/custom_deleting_alert_dialog.dart';
import 'package:mobi_wall/core/widgets/custom_slide_transition.dart';
import 'package:mobi_wall/core/widgets/empty_lottie_widget.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';

class UrlBlockingView extends StatelessWidget {
  const UrlBlockingView({
    super.key,
    required this.urls,
  });

  final List<String>? urls;

  @override
  Widget build(BuildContext context) {
    return urls == null || urls!.isEmpty
        ? const EmptyLottieWidget(lottie: AssetsData.emptyBoxLottie)
        : Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: urls!.length,
              itemBuilder: (context, index) {
                return CustomSlideTransition(
                    index: index,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              icon: IconBroken.Delete,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.red,
                              borderRadius: BorderRadius.circular(10.r),
                              autoClose: true,
                              onPressed: (BuildContext context) {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      BlocConsumer<ParentCubit, ParentState>(
                                    listener: (context, state) =>
                                        _listener(context, state),
                                    builder: (context, state) {
                                      return CustomDeletingAlertDialog(
                                        text: "Wanna delete this url !",
                                        loading: ParentCubit.get(context)
                                            .updateBlockedUrlsState
                                            .isLoading(),
                                        onDeleting: () {
                                          ParentCubit.get(context)
                                              .updateBlockedUrls(context,
                                                  url: urls![index],
                                                  delete: true);
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        child: CustomCard(
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              urls![index],
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            ),
          );
  }

  _listener(BuildContext context, ParentState state) {
    if (state is UpdateBlockedUrlsFailureState) {
      showAlertDialog(context, description: state.message);
    } else if (state is UpdateBlockedUrlsSuccessState) {
      Navigator.pop(context);
      Navigator.pop(context);
      showAlertDialog(
        context,
        state: AlertState.success,
        description: "Blocked urls are updated successfully",
      );
    }
  }
}
