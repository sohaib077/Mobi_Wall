import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobi_wall/core/helpers/extensions.dart';
import 'package:mobi_wall/core/utils/constants.dart';
import 'package:mobi_wall/features/auth/presentation/views/auth_view.dart';
import '../helpers/cache_helper.dart';
import '../services/firebase_services.dart';
import '../utils/background_services.dart';
import '../utils/icon_broken.dart';
import 'password_bottom_sheet.dart';
import 'shared_methods.dart';

class CustomLogOutButton extends StatelessWidget {
  const CustomLogOutButton({
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
                    borderRadius: BorderRadius.circular(20.res(context)),
                  ),
                  title: Column(
                    children: [
                      Icon(
                        IconBroken.Danger,
                        color: Colors.red,
                        size: 45.res(context),
                      ),
                      SizedBox(height: 10.res(context)),
                      FittedBox(
                        child: Text(
                          'Wanna logout !',
                          style: TextStyle(
                            letterSpacing: 0.5,
                            height: 0,
                            fontFamily: 'schoolBook',
                            fontSize: 22.res(context),
                            fontWeight: FontWeight.w600,
                          ),
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
                  actionsPadding: EdgeInsetsDirectional.only(
                    bottom: 10.res(context),
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
                              fontSize: 22.res(context),
                              // color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          style:
                              TextButton.styleFrom(foregroundColor: Colors.red),
                          onPressed: () async {
                            Navigator.pop(context);
                            showModalBottomSheet(
                              shape: Constants.modalSheetDecoration(),
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return PasswordBottomSheet(
                                    actionTitle: "L O G O U T",
                                    action: () {
                                      BackgroundServices.stopPeriodicTasks(
                                          context);
                                      logout(context);
                                    });
                              },
                            );
                          },
                          child: Text(
                            'Logout',
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
            });
      },
      icon: Icon(
        IconBroken.Logout,
        color: Colors.redAccent,
        size: height * 0.04,
      ),
    );
  }

  void logout(BuildContext context) {
    CacheHelper.removeData(Constants.cachedId);
    CacheHelper.removeData(Constants.cachedOtp);
    CacheHelper.removeData(Constants.cachedChild);
    Constants.otp = true;
    Constants.childData = null;
    FirebaseService().signOut();
    navigateAndFinish(context, const AuthView(), fade: true);
  }
}
