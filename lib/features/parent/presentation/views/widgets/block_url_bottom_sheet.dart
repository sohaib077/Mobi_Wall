import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/widgets/custom_animated_container.dart';
import 'package:mobi_wall/core/widgets/custom_bottom_sheet_text_form_field.dart';
import 'package:mobi_wall/core/widgets/custom_elevated_button.dart';
import 'package:mobi_wall/features/parent/presentation/manager/parent_cubit.dart';

class BlockUrlBottomSheet extends StatefulWidget {
  const BlockUrlBottomSheet({
    super.key,
  });

  @override
  State<BlockUrlBottomSheet> createState() => _BlockUrlBottomSheetState();
}

class _BlockUrlBottomSheetState extends State<BlockUrlBottomSheet> {
  TextEditingController urlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentCubit, ParentState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40.h),
                CustomBottomSheetTextFormField(
                  controller: urlController,
                  hintText: "Enter the url",
                  label: "URL",
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Enter a valid url";
                    }
                  },
                ),
                SizedBox(height: 40.h),
                CustomAnimatedContainer(
                  state: ParentCubit.get(context).updateBlockedUrlsState,
                  child: CustomElevatedButton(
                    text: 'Block',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ParentCubit.get(context).updateBlockedUrls(context,
                            url: urlController.text.trim());
                      }
                    },
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
