import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';

import '../functions/navigation.dart';
import '../helpers/cache_helper.dart';
import '../services/firebase_services.dart';
import '../utils/constants.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return IconButton(
      highlightColor: Colors.transparent,
      onPressed: () {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: AlertDialog(
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  title: Column(
                    children: [
                      Icon(
                        IconBroken.Danger,
                        color: Colors.red,
                        size: 45.h,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      FittedBox(
                        child: Text(
                          'Wanna logout !',
                          style: TextStyle(
                            letterSpacing: 0.5,
                            height: 0,
                            fontFamily: 'schoolBook',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  contentPadding: EdgeInsetsDirectional.only(
                    start: 50.w,
                    end: 30.w,
                    top: 12.h,
                    bottom: 0,
                  ),
                  actionsPadding: EdgeInsetsDirectional.only(
                    bottom: 10.h,
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            // cubit.getCharacters();
                            Navigator.pop(context); //close Dialog
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 22.sp,
                              // color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          style:
                              TextButton.styleFrom(foregroundColor: Colors.red),
                          onPressed: () async {
                            CacheHelper.removeData(Constants.cachedId);
                            CacheHelper.removeData(Constants.cachedOtp);
                            CacheHelper.removeData(Constants.cachedChild);
                            Constants.otp = true;
                          /// uncomment  Constants.childData = null;
                            FirebaseServices.signOut();
                          /// uncomment BackgroundServices.stopPeriodicTasks(context);
                          /// uncomment navigateAndFinish(context, const AuthView(),fade: true);
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 22.sp,
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
            });
      },
      icon: Icon(
        IconBroken.Logout,
        color: Colors.redAccent,
        size: height * 0.04,
      ),
    );
  }
}
