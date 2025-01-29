import 'package:flutter/material.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import '../utils/icon_broken.dart';
import '../utils/styles.dart';

class CustomDeletingAlertDialog extends StatelessWidget {
  const CustomDeletingAlertDialog({
    super.key,
    this.text,
    this.actionText = "Delete",
    required this.onDeleting,
    this.loading = false,
  });

  final String? text;
  final String actionText;
  final VoidCallback onDeleting;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.res(context)),
        ),
        title: Column(
          children: [
            Icon(
              IconBroken.Danger,
              color: Colors.red,
              size: 45.res(context),
            ),
            SizedBox(height: 20.res(context)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text ?? "Wanna delete this !",
                style: Styles.semiBold20Style(context)
                    .copyWith(color: Colors.black),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsetsDirectional.only(
          start: 50.res(context),
          end: 30.res(context),
          top: 12.res(context),
          bottom: 0,
        ),
        actionsPadding: EdgeInsetsDirectional.only(bottom: 10.res(context)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); //close Dialog
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 22.res(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              loading
                  ? const CircularProgressIndicator(color: Colors.redAccent)
                  : TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: onDeleting,
                      child: Text(
                        actionText,
                        style: TextStyle(
                          fontSize: 22.res(context),
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
