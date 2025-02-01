import 'package:flutter/material.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/widgets/empty_lottie_widget.dart';
import 'package:mobi_wall/features/children/data/models/calls_model.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/calls_item.dart';

class CallsList extends StatelessWidget {
  const CallsList({
    super.key,
    required this.calls,
  });

  final List<CallsModel>? calls;

  @override
  Widget build(BuildContext context) {
    return calls == null || calls!.isEmpty
        ? const EmptyLottieWidget(lottie: AssetsData.emptyBoxLottie)
        : Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: calls!.length,
              itemBuilder: (context, index) {
                return CallItem(call: calls![index], index: index);
              },
            ),
          );
  }
}
