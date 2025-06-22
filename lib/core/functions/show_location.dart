import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/features/children/data/models/location_data_model.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showLocation(
    BuildContext context, LocationDataModel location) async {
  String latitude = location.latitude.toString();
  String longitude = location.longitude.toString();
  try {
    final Uri link = Uri.parse(
      "https://www.google.com/maps?q=$latitude,$longitude",
    );
    await launchUrl(link);
  } catch (e) {
    log(e.toString());
    showAlertDialog(context,
        state: AlertState.failed, description: "\nOops, something wrong\n");
  }
}
