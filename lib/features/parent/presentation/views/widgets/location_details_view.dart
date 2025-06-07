import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocode/geocode.dart';
import 'package:lottie/lottie.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/utils/size_config.dart';
import 'package:mobi_wall/core/widgets/custom_address_text_form_field.dart';
import 'package:mobi_wall/core/widgets/custom_animated_button.dart';
import 'package:mobi_wall/core/widgets/custom_empty_state_widget.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobi_wall/features/children/data/models/location_data_model.dart';

class LocationDetailsView extends StatefulWidget {
  const LocationDetailsView({
    super.key,
    required this.location,
  });

  final LocationDataModel? location;

  @override
  State<LocationDetailsView> createState() => _LocationDetailsViewState();
}

class _LocationDetailsViewState extends State<LocationDetailsView> {
  Address? address;
  late bool flag;

  @override
  void initState() {
    super.initState();
    flag = address == null || address!.city!.contains("Throttled");
    if (flag && widget.location != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getAddress();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.location == null
        ? const CustomEmptyStateWidget(lottie: AssetsData.emptyBoxLottie)
        : Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Lottie.asset(
                    AssetsData.addressLottie,
                    repeat: false,
                    fit: BoxFit.contain,
                    height: SizeConfig.screenHeight * 0.2,
                  ),
                  SizedBox(height: 20.h),
                  CustomAddressTextFormField(
                    controller: TextEditingController(
                        text: (address == null ? "loading..." : address!.city)),
                    hintText: " ",
                    enabled: false,
                    label: "CITY",
                  ),
                  SizedBox(height: 30.h),
                  CustomAddressTextFormField(
                    controller: TextEditingController(
                      text: (address == null
                          ? "loading..."
                          : address!.streetAddress),
                    ),
                    hintText: " ",
                    enabled: false,
                    label: "STREET",
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomAddressTextFormField(
                          controller: TextEditingController(
                              text:
                                  widget.location!.latitude.toStringAsFixed(2)),
                          hintText: " ",
                          enabled: false,
                          label: "LATITUDE",
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomAddressTextFormField(
                          controller: TextEditingController(
                              text: widget.location!.longitude
                                  .toStringAsFixed(2)),
                          hintText: " ",
                          enabled: false,
                          label: "LONGITUDE",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  CustomAnimatedButton(
                    text: "Show Location",
                    onPressed: () async {
                      String latitude = widget.location!.latitude.toString();
                      String longitude = widget.location!.longitude.toString();
                      try {
                        final Uri link = Uri.parse(
                          "https://www.google.com/maps?q=$latitude,$longitude",
                        );
                        await launchUrl(link);
                      } catch (e) {
                        log(e.toString());
                        showAlertDialog(context,
                            state: AlertState.failed,
                            description: "\nOops, something wrong\n");
                      }
                    },
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          );
  }

  Future<void> getAddress() async {
    GeoCode geoCode = GeoCode();
    address = await geoCode.reverseGeocoding(
        latitude: widget.location!.latitude,
        longitude: widget.location!.longitude);

    log(address?.toString() ?? "null");
    setState(() {});
    // return "${address.city} -- ${address.streetAddress}";
  }
}
