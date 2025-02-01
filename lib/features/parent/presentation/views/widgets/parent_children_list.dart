import 'package:flutter/material.dart';
import 'package:mobi_wall/features/parent/data/models/child_data_model.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/child_item.dart';

class ParentChildrenList extends StatelessWidget {
  const ParentChildrenList({
    super.key,
    required this.children,
  });

  final List<ChildDataModel> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        children.length,
        (index) => ChildItem(
          child: children[index],
          index: index,
        ),
      ),
    );
  }
}
